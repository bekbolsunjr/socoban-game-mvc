import UIKit

public class Controller: UIViewController {
    private let model: Model
    private var x1: Double?
    private var y1: Double?
    private var x2: Double?
    private var y2: Double?
    
    public init(viewer: Viewer) {
        print("Controller Iam")
        model = Model(viewer: viewer)
        super.init(nibName: nil, bundle: nil)
        view.contentMode = .scaleToFill
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            x1 = Double(position.x)
            y1 = Double(position.y)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            x2 = Double(position.x)
            y2 = Double(position.y)
        }
        move()
    }
    
    public func getModel() -> Model {
        return model
    }
    
    private func move() {
        var direction = ""
        let deltaX = x1! - x2!
        let deltaY = y1! - y2!
        if abs(deltaX) > abs(deltaY) {
            if deltaX < 0 {
                direction = "Right"
            } else {
                direction = "Left"
            }
        } else {
            if deltaY < 0 {
                direction = "Down"
            } else {
                direction = "Up"
            }
        }
        model.move(direction: direction)
    }
}
