//
//  GameboardView.swift
//  MineSweeper
//
//  Created by Cofyc on 9/14/14.
//  Copyright (c) 2014 Cofyc. All rights reserved.
//

import UIKit

protocol GameboardDelegate: class {
    func revealGrid(pos: (Int, Int))
}

/**
 *
 * A board containing grids. (262x262)
 *
 */
class GameboardView: UIView, UIGestureRecognizerDelegate {

    var dimension: Int = 10
    var gridPadding: CGFloat = 2.0
    var gridWidth: CGFloat = 24.0
    var cornerRadius: CGFloat = 2.0
    var bgColor: UIColor = UIColor.whiteColor()
    var gridColor: UIColor = UIColor.grayColor()

    var gridPopStartScale: CGFloat = 0.1

    var grids: Dictionary<NSIndexPath, GridView> = Dictionary()
    var delegate: GameboardDelegate?

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // background
        self.backgroundColor = UIColor.blackColor()
        // background for grid
        var xCursor:CGFloat = gridPadding
        var yCursor:CGFloat = gridPadding
        for i in 0..<dimension {
            // draw a row
            for j in 0..<dimension {
                let grid = UIView(frame: CGRectMake(xCursor, yCursor, gridWidth, gridWidth))
                grid.layer.cornerRadius = cornerRadius
                grid.backgroundColor = gridColor
                addSubview(grid)
                xCursor += gridPadding + gridWidth
            }
            xCursor = gridPadding
            yCursor += gridPadding + gridWidth
        }
    }

    func reset() {
        for (key, grid) in grids {
            grid.removeFromSuperview()
        }
        grids.removeAll(keepCapacity: true)
    }

    /// Return whether a given position is valid. Used for bounds checking.
    func positionIsValid(pos: (Int, Int)) -> Bool {
        let (x, y) = pos
        return (x >= 0 && x < dimension && y >= 0 && y < dimension)
    }

    // Update a grid.
    func updateGrid(pos: (Int, Int), value: Int) {
        assert(positionIsValid(pos))
        let (row, col) = pos
        let x = gridPadding + CGFloat(col)*(gridWidth + gridPadding)
        let y = gridPadding + CGFloat(row)*(gridWidth + gridPadding)
        let grid = GridView(frame: CGRectMake(x, y, gridWidth, gridWidth), pos: pos, value: value)
        grid.addTarget(self, action: "tap:", forControlEvents: UIControlEvents.TouchUpInside)
        var longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPressGesture:")
        longPressGesture.delegate = self
        longPressGesture.minimumPressDuration = 0.5
        grid.addGestureRecognizer(longPressGesture)
        addSubview(grid)
        bringSubviewToFront(grid)
        grids[NSIndexPath(forRow: row, inSection: col)] = grid
    }

    func revealGrid(pos: (Int, Int)) {
        assert(positionIsValid(pos))
        let (row, col) = pos
        var grid:GridView = grids[NSIndexPath(forRow: row, inSection: col)]!
        grid.revealed = true
        grid.update()
    }

    // tap a grid
    func tap(sender: GridView!) {
        println("tap")
        sender.revealed = true
        sender.update()
        self.delegate?.revealGrid((sender.x, sender.y))
    }

    // tap and hold a grid
    func handleLongPressGesture(recognizer: UILongPressGestureRecognizer) {
        if (recognizer.state == UIGestureRecognizerState.Ended) {
            return
        }
        let sender = recognizer.view? as GridView
        println("tapAndHold")
        sender.flagged = !sender.flagged
        if (sender.flagged) {
            println("flagged:")
        } else {
            println("flagged: no")
        }
        sender.update()
    }
}
