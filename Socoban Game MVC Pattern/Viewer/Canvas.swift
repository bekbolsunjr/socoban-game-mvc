import UIKit

//@IBDesignable

public class Canvas: UIView {
    private let model: Model
    
    
    private var heroUp = UIImage(named: "up")
    private var heroLeft = UIImage(named: "left")
    private var heroDown = UIImage(named: "down")
    private var heroRight = UIImage(named: "right")
    private var wall = UIImage(named: "wall")
    private var rbox = UIImage(named: "rbox")
    private var bbox = UIImage(named: "box")
    private var goal = UIImage(named: "goal")
    private var ground = UIImage(named: "ground")
    
    
    private var emptySpace = 0
    private var player = 1
    private var walls = 2
    private var box = 3
    private var target = 4
    private var boxOnTarget = 5

    public init(frame: CGRect, model: Model) {
        print("Canvas Iam")
        self.model = model
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update() {
        setNeedsDisplay()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if model.getStateModel() {
            drawMap()
        } else {
            
        }
    }
    
    private func errorGame() {
        print("xxxxx")
    }
    
    private func drawMap() {
        let desktop = model.getmap()
        var x: CGFloat = UIDevice.current.orientation.isLandscape ? (frame.width - frame.height) / 2 : 0
        var y: CGFloat = UIDevice.current.orientation.isLandscape ? 0 : (frame.height - frame.width) / 2
        let width: CGFloat = (UIDevice.current.orientation.isLandscape ? frame.height: frame.width) / CGFloat(desktop.count)
        let height: CGFloat = (UIDevice.current.orientation.isLandscape ? frame.height: frame.width) / CGFloat(desktop.count)
        
        for i in desktop {
            for j in i {
                switch j {
                case emptySpace:
                    ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                case player:
                    ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    switch model.getPlayersFace() {
                    case .down:
                        heroDown?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    case .up:
                        heroUp?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    case .left:
                        heroLeft?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    case .right:
                        heroRight?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    }
                    
                case walls:
                    ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    wall?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                case box:
                    ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    bbox?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                case target:
                    ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    goal?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                case boxOnTarget:
                    ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                    rbox?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                default:
                    ground?.draw(in: CGRect (x: x, y: y, width: width, height: height))
                }
                x += width
            }
            x = UIDevice.current.orientation.isLandscape ? (frame.width - frame.height) / 2 : 0
            y += height
        }
        
    }
}
