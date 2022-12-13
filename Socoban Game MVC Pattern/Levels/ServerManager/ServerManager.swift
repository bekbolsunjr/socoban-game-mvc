//
//  ServerManager.swift
//  Socoban Game MVC Pattern
//
//  Created by bekbolsun on 28/9/22.
//

import Foundation
import Network

public class ServerManager: NSObject {
    
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    
    
    private var maxReadLength: Int = 4096
    private var socketTimeoutTimer: Timer?
    private var messageEncoding: String.Encoding?    
    internal var didRecieveMessage: ((_ message: String) -> ())?
    internal var didRecieveError: ((_ error: Error) -> ())?
    internal var connectionCompleted: (() -> ())?
    
    init(host: String, port: UInt32, messageEncoding encoding: String.Encoding? = nil) {
        super.init()
        messageEncoding = encoding
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           host as CFString,
                                           port,
                                           &readStream,
                                           &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        inputStream?.delegate = self
        inputStream?.schedule(in: .current, forMode: .common)
        outputStream?.schedule(in: .current, forMode: .common)
        inputStream?.open()
        outputStream?.open()
        
        setSocketTimeoutTimer(seconds: 2.0)
    }
    
    public func sendMessage(message: String) {
        let messageWithNewLine = message + "\n"
        let data = messageWithNewLine.data(using: .utf8)!
        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Unexpected exception!")
                return
            }
            outputStream?.write(pointer, maxLength: data.count)
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        var numberOfBytesRead = 0
        while stream.hasBytesAvailable {
            numberOfBytesRead = stream.read(buffer, maxLength: maxReadLength)
        }
        let decodedMessage = decodeMessage(buffer: buffer, length: numberOfBytesRead)
        if var message = decodedMessage {
            message = message.replacingOccurrences(of: "\0", with: "")
            message = message.replacingOccurrences(of: "\r", with: "")
            message = message.replacingOccurrences(of: "\u{0C}", with: "")
            message = message.replacingOccurrences(of: "\u{0B}", with: "")
            message = message.replacingOccurrences(of: "GOT_LEVEL: ", with: "")
            message = message.replacingOccurrences(of: "END_OF_MESSAGE", with: "")
            didRecieveMessage?(message)
        }
    }
    
    private func decodeMessage(buffer: UnsafeMutablePointer<UInt8>, length: Int) -> String? {
        guard let message = String(bytesNoCopy: buffer, length: length, encoding: messageEncoding ?? .utf8, freeWhenDone: true) else {return nil}
        return message
    }
    
    private func connectionOpened() {
        stopSocketTimeoutTimer()
        connectionCompleted?()
        print("Connected successfully!")
    }
    
    private func serverDisconnected() {
        print("Server disconnected!")
        closeConnection()
    }
    
    private func closeConnection() {
        inputStream?.close()
        outputStream?.close()
        inputStream = nil
        outputStream = nil
    }
    deinit {
        closeConnection()
        stopSocketTimeoutTimer()
    }
}

extension ServerManager {
    private func setSocketTimeoutTimer(seconds: Float = 4.0) {
        let timeInterval = TimeInterval(exactly: seconds)!
        socketTimeoutTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] (timer) in
            self?.closeConnection()
        })
        socketTimeoutTimer?.tolerance = 0.1
    }
    private func stopSocketTimeoutTimer() {
        socketTimeoutTimer?.invalidate()
    }
}
extension ServerManager : StreamDelegate {
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
            case .hasBytesAvailable:
                readAvailableBytes(stream: aStream as! InputStream)
            case .openCompleted:
                connectionOpened()
            case .errorOccurred:
                stopSocketTimeoutTimer()
            case .endEncountered:
                serverDisconnected()
            default:
                print("Some event happened...")
        }
    }
}

