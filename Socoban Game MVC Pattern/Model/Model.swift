import Foundation

public class Model {
    
    private var emptySpace = 0
    private var player = 1
    private var wall = 2
    private var box = 3
    private var target = 4
    private var boxOnTarget = 5
    
    // MARK: - private global variables
    private let viewer: Viewer
    private let levels: Levels
    private var map: [[Int]]!
    private var heroX = 0
    private var heroY = 0
    private var playersFaceLookingDirection: PlayersFace = .down
    private var currentLevel = 1
    private var showlvl = 0
    private var indexOfArr: [[Int]]!
    private var stateModel: Bool
    
    // MARK: - INIT
    public init(viewer: Viewer) {
        print("Model Iam")
        self.viewer = viewer
        levels = Levels()
        map = levels.getLevel(lvl: currentLevel)
        stateModel = true
        initialization()
        MusicPlayer.shared.startBackgroundMusic()
    }
    
    // MARK: - INIT
    private func initialization() {
        map = levels.getLevel(lvl: currentLevel)
        print("init")

        var countOne = 0
        var countThree = 0
        var countFour = 0

        for i in 0..<map.count {
            for j in 0..<map[i].count {
                if map[i][j] == 1 {
                    countOne = countOne + 1
                    heroX = i
                    heroY = j
                } else if map[i][j] == 3 {
                    countThree = countThree + 1
                } else if map[i][j] == 4 {
                    countFour = countFour + 1
                }
            }
        }

        if countOne != 1 {
            stateModel = false
            return
        }

        if !(countThree != 0 && countFour != 0 && countFour == countThree) {
            stateModel = false
            return
        }

        indexOfArr = Array(repeating: Array(repeating: 0, count: countFour), count: 2)

        var t = 0
        for i in 0..<map.count {
            for j in 0..<map[i].count {
                if map[i][j] == 4 {
                    indexOfArr[0][t] = i
                    indexOfArr[1][t] = j
                    t = t + 1
                }
            }
        }
    }

    private func win() {
        var win = true

        for j in 0..<indexOfArr[0].count {
            let x = indexOfArr[0][j]
            let y = indexOfArr[1][j]

            if map[x][y] != 3 {
                win = false
                break
            }
        }
        
        if win {
            print("win")
            viewer.update()
            currentLevel += 1
            initialization()
            startNewLevel()
            showlvl = currentLevel - 1
            viewer.showMessageDialog(lvl: showlvl)
        }
    }
    
    public func startNewLevel() {
        map = levels.getLevel(lvl: currentLevel)
        playersFaceLookingDirection = .down
        viewer.update()
    }
    
    // MARK: move direction
    public func move(direction: String) {
        switch direction {
        case "Left":
            moveLeft()
            break
        case "Right":
            moveRight()
            break
        case "Up":
            moveUp()
            break
        case "Down":
            moveDown()
            break
        default:
            return
        }
        print("move")
        viewer.update()
        win()
    }
    
    private func printmap() {
        print("printMap")
        for i in 0..<map.count {
            for j in 0..<map[i].count {
                print(map[i][j], terminator: " ")
            }
            print("")
        }
        print("")
    }
    
    // MARK: - move Left
    private func moveLeft() {
        if map[heroX][heroY - 1] == box {
            if map[heroX][heroY - 2] == emptySpace || map[heroX][heroY - 2] == target {
                map[heroX][heroY - 1] = emptySpace
                map[heroX][heroY - 2] = box
            }
        }
        if map[heroX][heroY - 1] == emptySpace || map[heroX][heroY - 1] == target {
            map[heroX][heroY] = emptySpace
            heroY = heroY - 1
            map[heroX][heroY] = player
        }
        playersFaceLookingDirection = .left
    }
    
    // MARK: - move Right
    private func moveRight() {
        if map[heroX][heroY + 1] == box {
            if map[heroX][heroY + 2] == emptySpace || map[heroX][heroY + 2] == target {
                map[heroX][heroY + 1] = emptySpace
                map[heroX][heroY + 2] = box
            }
        }
        if map[heroX][heroY + 1] == emptySpace || map[heroX][heroY + 1] == target {
            map[heroX][heroY] = emptySpace
            heroY = heroY + 1
            map[heroX][heroY] = player
        }
        playersFaceLookingDirection = .right
    }
    
    // MARK: - move UP
    private func moveUp() {
        if map[heroX - 1][heroY] == box {
            if map[heroX - 2][heroY] == emptySpace || map[heroX - 2][heroY] == target {
                map[heroX - 1][heroY] = emptySpace
                map[heroX - 2][heroY] = box
            }
        }
        if map[heroX - 1][heroY] == emptySpace || map[heroX - 1][heroY] == target {
            map[heroX][heroY] = emptySpace
            heroX = heroX - 1
            map[heroX][heroY] = player
        }
        playersFaceLookingDirection = .up
    }
    
    // MARK: - move Down
    private func moveDown() {
        if map[heroX + 1][heroY] == box {
            if map[heroX + 2][heroY] == emptySpace || map[heroX + 2][heroY] == target{
                map[heroX + 1][heroY] = emptySpace
                map[heroX + 2][heroY] = box
            }
        }
        if map[heroX + 1][heroY] == emptySpace || map[heroX + 1][heroY] == target {
            map[heroX][heroY] = emptySpace
            heroX = heroX + 1
            map[heroX][heroY] = player
        }
        playersFaceLookingDirection = .down
    }

    public func getPlayersFace() -> PlayersFace {
        return playersFaceLookingDirection
    }
    
    // MARK: - returning map
    public func getmap() -> [[Int]]{
        return map
    }
    
    public func getStateModel() -> Bool {
        return stateModel
    }
    
    public func startLevel(_ number: Int) {
        currentLevel = number
        startNewLevel()
    }
}
