//
//  StatusView.swift
//  MineSweeper
//
//  Created by Cofyc on 9/14/14.
//  Copyright (c) 2014 Cofyc. All rights reserved.
//

import UIKit

class StatusView : UIView {

    var score: Int = 0 {
        didSet {
//            label?.text = "score: \(score) / 10"
        }
    }

    var label: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: frame)
        label?.textAlignment = NSTextAlignment.Center
        backgroundColor = UIColor.whiteColor()
        label?.textColor = UIColor.blackColor()
        label?.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        layer.cornerRadius = 6
        self.addSubview(label!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func scoreChanged(newScore s: Int)  {
        score = s
    }
}