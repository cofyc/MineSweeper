//
//  ViewController.swift
//  MineSweeper
//
//  Created by Cofyc on 9/14/14.
//  Copyright (c) 2014 Cofyc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameModelDelegate, GameboardDelegate {

    var gameboard:GameboardView?
    var status:StatusView?
    var model:GameModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let vcHeight = view.bounds.size.height
        let vcWidth = view.bounds.size.width
        let gameboardFrame = CGRectMake((vcWidth - 262)/2, (vcHeight - 262)/2, 262, 262)

        gameboard = GameboardView(frame: gameboardFrame)
        gameboard?.delegate = self
        self.view.addSubview(gameboard!)

        status = StatusView(frame: CGRectMake((vcWidth - 262)/2, 20, 140, 40))
        status?.score = 0
        self.view.addSubview(status!)

        model = GameModel(delegate: self)
        model?.reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertGrid(pos: (Int, Int), value: Int) {
        gameboard!.updateGrid(pos, value: value)
    }

    func notifyRevealGrid(pos: (Int, Int)) {
        gameboard!.revealGrid(pos)
    }

    func revealGrid(pos: (Int, Int)) {
        let (x, y) = pos
        println("reveal grid: %d, %d".format(x, y))
        if model!.revealGrid(pos) {
            var refreshAlert = UIAlertController(title: "Game Over!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.gameboard?.reset()
                self.model?.reset()
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        } else {
            if model!.finished() {
                var refreshAlert = UIAlertController(title: "You Win!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    self.gameboard?.reset()
                    self.model?.reset()
                }))
                presentViewController(refreshAlert, animated: true, completion: nil)
            }
        }
    }

}

