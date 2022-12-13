//
//  Levels.swift
//  Socoban Game MVC Pattern
//
//  Created by bekbolsun on 20/9/22.
//
import Foundation

class Levels {
    
    private let levelParser: LevelParser
    private var fouthLevel = [[Int]]()
    private var fifthLevel = [[Int]]()
    private var sixthLevel = [[Int]]()
    
    init() {
        levelParser = LevelParser()
    }
    
    public func getLevel(lvl: Int) -> [[Int]] {
        switch lvl {
        case 1:
            return getFirstLevel()
        case 2:
            return getSecondLevel()
        case 3:
            return getThirdLevel()
        case 4:
            return levelParser.parseFour()
        case 5:
            return levelParser.parseFive()
        case 6:
            return levelParser.parseSix()
        case 7:
            return levelParser.parseSeven()
        case 8:
            return levelParser.parseEight()
        case 9:
            return levelParser.parseNine()
        default:
            return getFirstLevel()
        }
    }

    
    public func getFourthLevel() -> [[Int]] {
        return fouthLevel
    }
    
    public func getFifthLevel() -> [[Int]] {
        return fifthLevel
    }
    public func getSixthLevel() -> [[Int]] {
        return sixthLevel
    }
    
    
    private func getFirstLevel() -> [[Int]] {
        let array: [[Int]] = [
            [2, 2, 2, 2, 2, 2, 2, 2],
            [2, 0, 2, 0, 0, 0, 2, 2],
            [2, 0, 3, 0, 0, 0, 0, 2],
            [2, 0, 2, 0, 0, 4, 0, 2],
            [2, 0, 0, 0, 0, 0, 0, 2],
            [2, 2, 0, 2, 2, 2, 2, 2],
            [2, 0, 1, 0, 0, 0, 0, 2],
            [2, 2, 2, 2, 2, 2, 2, 2]
        ]
        print("1lvl")
        return array
    }
    
    private func getSecondLevel() -> [[Int]] {
        let array: [[Int]] = [
            [2, 2, 2, 2, 2, 2, 2, 2],
            [2, 0, 2, 0, 0, 0, 2, 2],
            [2, 0, 3, 0, 0, 0, 0, 2],
            [2, 0, 2, 0, 0, 4, 2, 2],
            [2, 0, 0, 4, 0, 2, 0, 2],
            [2, 0, 3, 2, 0, 2, 0, 2],
            [2, 0, 1, 2, 0, 0, 0, 2],
            [2, 2, 2, 2, 2, 2, 2, 2]
        ]
        print("2lvl")
        return array
    }
    
    private func getThirdLevel() -> [[Int]] {
        let array: [[Int]] = [
            [2, 2, 2, 2, 2, 2, 2, 2],
            [2, 0, 2, 4, 0, 0, 0, 2],
            [2, 0, 3, 0, 0, 2, 0, 2],
            [2, 0, 2, 0, 0, 4, 2, 2],
            [2, 0, 0, 0, 0, 2, 0, 2],
            [2, 0, 3, 2, 0, 2, 0, 2],
            [2, 0, 1, 0, 0, 0, 0, 2],
            [2, 2, 2, 2, 2, 2, 2, 2]
        ]
        print("3lvl")
        return array
    }

}
