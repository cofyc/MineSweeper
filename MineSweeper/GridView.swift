//
//  GridView.swift
//  MineSweeper
//
//  Created by Cofyc on 9/14/14.
//  Copyright (c) 2014 Cofyc. All rights reserved.
//

import UIKit

/**
 * View to represents a single grid.
 */
class GridView: UIButton {

    var x: Int = 0
    var y: Int = 0

    var value: Int = 0

    var flagged: Bool = false

    var revealed: Bool = false

    var numberLabel: UILabel?

    var mineImage:UIImage = UIImage(named: "mine")
    var flagImage:UIImage = UIImage(named: "flag")
    var flagImageView:UIImageView?

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(frame: CGRect, pos: (Int, Int), value: Int) {
        let (x, y) = pos
        self.x = x
        self.y = y
        super.init(frame: frame)
        layer.cornerRadius = 2
        self.value = value
    }

    func update() {
        var width = self.frame.size.width - 2
        let frame = CGRectMake(0, 0, width, width)
        if (!revealed) {
            if (flagged) {
                if flagImageView == nil {
                    flagImageView = UIImageView(frame: frame)
                    flagImageView?.image = flagImage
                    addSubview(flagImageView!)
                }
            } else {
                if flagImageView != nil {
                    flagImageView?.removeFromSuperview()
                    flagImageView = nil
                }
            }
            return
        }
        // clear flag
        if flagImageView != nil {
            flagImageView?.removeFromSuperview()
            flagImageView = nil
        }
        if value < 0 {
            // has mine
            self.backgroundColor = UIColor.redColor()
            let mine = UIImageView(frame: frame)
            mine.image = mineImage
            addSubview(mine)
        } else if (value == 0) {
            self.backgroundColor = UIColor.whiteColor()
            // pass
        } else {
            self.backgroundColor = UIColor.whiteColor()
            if numberLabel == nil {
                numberLabel = UILabel(frame: frame)
                numberLabel?.textAlignment = NSTextAlignment.Center
                numberLabel?.minimumScaleFactor = 0.5
                numberLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                addSubview(numberLabel!)
            }
            numberLabel?.textColor = colorForNumber(value)
            numberLabel?.text = "%d".format(value)
        }
    }

    // color for number
    func colorForNumber(value: Int) -> UIColor {
        switch value {
        case 1:
            return UIColor.blueColor()
        case 2:
            return UIColor.greenColor()
        case 3:
            return UIColor.redColor()
        default:
            return UIColor.redColor()
        }
    }

}
