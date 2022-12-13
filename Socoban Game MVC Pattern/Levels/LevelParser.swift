//
//  LevelParser.swift
//  Socoban Game MVC Pattern
//
//  Created by bekbolsun on 25/9/22.
//

import Foundation


public class LevelParser{
    
    private var remote: RemoteServerManager
    
    init() {
        remote = RemoteServerManager.shared
        getFromServers()
    }
    private var seven = [[Int]]()
    private var eight = [[Int]]()
    private var nine = [[Int]]()
    
    private func run(after seconds: Int, completion: @escaping () -> ()) {
        print("run")
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    private func getFromServers() {
        remote.getLevel(levelName: "Level7.txt")
        run(after: 2) { [self] in
            seven = parseServerMap(Map: remote.getMap())
            remote.getLevel(levelName: "Level8.txt")
            run(after: 2) {
                eight = parseServerMap(Map: remote.getMap())
                remote.getLevel(levelName: "Level9.txt")
                run(after: 2) {
                    nine = parseServerMap(Map: remote.getMap())
                }
            }
        }
    }
    
    
    
    public func parseFour() -> [[Int]] {
        return parsing(level: 4)
    }
    public func parseFive() -> [[Int]] {
        return parsing(level: 5)
    }
    public func parseSix() -> [[Int]] {
        return parsing(level: 6)
    }
    public func parseSeven() -> [[Int]] {
        return seven
    }
    public func parseEight() -> [[Int]] {
        return eight
    }
    public func parseNine() -> [[Int]] {
        return nine
    }
    
    
    private func parsing(level: Int) -> [[Int]] {
        print("pars")
        let filePath = Bundle.main.path(forResource: "Level\(level)", ofType: "txt")
        var data = ""
        do {
            data = try String(contentsOfFile: filePath!, encoding: .utf8)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        data = data.filter {
            $0.isNumber || $0.isNewline
        }
        var map = [[Int]]()
        var subarray = [Int]()
        data += " "
        for i in data {
            if let int = Int(String(i)) {
                subarray.append(int)
            } else if i.isWhitespace && subarray.count != 0 {
                map.append(subarray)
                subarray = []
            }
        }
        return map
    }
    
    private func parseServerMap(Map: String) -> [[Int]] {
        var data = Map
        data = data.filter {
            $0.isNumber || $0.isNewline
        }
        var map = [[Int]]()
        var subarray = [Int]()
        data += " "
        for i in data {
            if let int = Int(String(i)) {
                subarray.append(int)
            } else if i.isWhitespace && subarray.count != 0 {
                map.append(subarray)
                subarray = []
            }
        }
        return map
    }

    
}
