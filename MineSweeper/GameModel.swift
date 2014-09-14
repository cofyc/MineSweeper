//
//  GameModel.swift
//  MineSweeper
//
//  Created by Cofyc on 9/14/14.
//  Copyright (c) 2014 Cofyc. All rights reserved.
//

import UIKit

/// An enum representing either an mine grid or a number.
enum GridObject {
    case Mine
    case Value(Int)
    case Revealed
    case Empty
}

/// A struct representing a square gameboard. Because this struct uses generics, it could conceivably be used to
/// represent state for many other games without modification.
struct SquareGameboard<T> {
    let dimension: Int
    var boardArray: [T]

    init(dimension d: Int, initialValue: T) {
        dimension = d
        boardArray = [T](count:d*d, repeatedValue:initialValue)
    }

    subscript(row: Int, col: Int) -> T {
        get {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            return boardArray[row*dimension + col]
        }
        set {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            boardArray[row*dimension + col] = newValue
        }
    }

    // We mark this function as 'mutating' since it changes its 'parent' struct.
    mutating func setAll(item: T) {
        for i in 0..<dimension {
            for j in 0..<dimension {
                self[i, j] = item
            }
        }
    }

    func count() -> Int {
        return dimension * dimension
    }

    func slots() -> [(Int, Int)] {
        var buffer = Array<(Int, Int)>()
        for i in 0..<dimension {
            for j in 0..<dimension {
                buffer += [(i, j)]
            }
        }
        return buffer
    }
}

protocol GameModelDelegate: class {
    func insertGrid(pos: (Int, Int), value: Int)
    func notifyRevealGrid(pos: (Int, Int))
}

class GameModel: NSObject {

    var gameboard: SquareGameboard<GridObject>
    var delegate: GameModelDelegate
    var dimension: Int = 10

    init(delegate: GameModelDelegate) {
        self.delegate = delegate
        gameboard = SquareGameboard(dimension: 10, initialValue: .Value(0))
    }

    func reset() {
        gameboard.setAll(.Empty)
        // mines
        let slots = gameboard.slots()
        for i in 0..<8 {
            let idx = Int(arc4random_uniform(UInt32(slots.count - 1)))
            let (x, y) = slots[idx]
            self.insertGrid((x, y), value: .Mine)
        }
        // remain
        let emptySlots = self.emptySlots()
        for (x, y) in emptySlots {
            self.insertGrid((x, y), value: .Value(numberOfAroundMines((x, y))))
        }
    }

    func numberOfAroundMines(pos: (Int, Int)) -> Int {
        let (x, y) = pos
        var number:Int = 0
        for i in x-1...x+1 {
            for j in y-1...y+1 {
                if i == x && j == y {
                    continue
                }
                if (i < 0 || i >= dimension) {
                    continue
                }
                if (j < 0 || j >= dimension) {
                    continue
                }
                switch gameboard[i, j] {
                case .Mine:
                    number++
                default:
                    break
                }
            }
        }
        return number
    }

    func insertGrid(pos: (Int, Int), value: GridObject) {
        let (x, y) = pos
        gameboard[x, y] = value
        switch value {
        case .Value(let value):
            delegate.insertGrid(pos, value: value)
            break
        case .Mine:
            delegate.insertGrid(pos, value: -1)
            break
        default:
            break;
        }
    }

    func emptySlots() -> [(Int, Int)] {
        var buffer = Array<(Int, Int)>()
        for i in 0..<dimension {
            for j in 0..<dimension {
                switch gameboard[i, j] {
                case .Empty:
                    buffer += [(i, j)]
                default:
                    break;
                }
            }
        }
        return buffer
    }


    func revealGrid(pos: (Int, Int)) -> Bool {
        let (x, y) = pos
        switch gameboard[x, y] {
        case .Mine:
            return true
        case .Value(let value):
            gameboard[x, y] = .Revealed
            if (value != 0) {
                return false
            }
            // revealall neighbors till grids are found that do have surrounding mines
            for i in x-1...x+1 {
                for j in y-1...y+1 {
                    if i == x && j == y {
                        continue
                    }
                    if (i < 0 || i >= dimension) {
                        continue
                    }
                    if (j < 0 || j >= dimension) {
                        continue
                    }
                    switch gameboard[i,j] {
                    case .Value:
                        revealGrid((i, j))
                        delegate.notifyRevealGrid((i, j))
                        break;
                    case .Empty:
                        revealGrid((i, j))
                        delegate.notifyRevealGrid((i, j))
                        break;
                    default:
                        continue
                    }
                }
            }
            return false
        default:
            return false
        }
    }

    func finished() -> Bool {
        for i in 0..<dimension {
            for j in 0..<dimension {
                switch gameboard[i, j] {
                case .Value:
                    println("i: %d, j: %d has value".format(i, j))
                    return false
                default:
                    break;
                }
            }
        }
        return true
    }
}
