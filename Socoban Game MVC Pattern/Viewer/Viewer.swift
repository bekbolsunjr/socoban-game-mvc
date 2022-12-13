import UIKit

@main

public class Viewer: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    private var canvas: Canvas?
    private var controller: Controller!
    
    public override init() {
        print("Viewer Iam")
        super.init()
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        controller = Controller(viewer: self)
        let model: Model = controller.getModel()
        let controllerFrame = controller.view.frame
        canvas = Canvas(frame: controllerFrame, model: model)
        controller.view.addSubview(canvas!)
        window?.contentMode = .scaleToFill
        window?.backgroundColor = .systemRed
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        checkIfConnectedToServer()
        
    }
    //MARK: ShowMAssage
    public func showMessageDialog(lvl: Int) {
        let alert = UIAlertController(title: "You seved the planet", message: "Superman \(lvl) level Win!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save the next planet", style: .default))
        window?.rootViewController?.present(alert, animated: true)
}
    
    //MARK: Chek Conekt
    private func checkIfConnectedToServer() {
        let a = RemoteServerManager.shared
        if !a.checkConnection() {
        }
    }
    
    //MARK: UPDATE
    public func update() {
        canvas!.update()
    }
    
}
