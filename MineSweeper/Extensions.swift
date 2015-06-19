//
//  Extensions.swift
//
//  Created by Cofyc on 8/31/14.
//
//

import Foundation
import CoreGraphics

// Add format function for String type.
func StringWithFormat(format: String, args: CVarArgType...) -> String {
    return NSString(format: format, arguments: getVaList(args)) as String
}

extension String {
    func format(args: CVarArgType...) -> String {
        return NSString(format: self, arguments: getVaList(args)) as String
    }
}

// Convenient operators.
infix operator ** { associativity left precedence 160 }
func ** (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

func ** (radix: CFloat, power: CFloat) -> CFloat {
    return CFloat(pow(Double(radix), Double(power)))
}

// CGPoint operators
func + (a:CGPoint, b:CGPoint) -> CGPoint {
    return CGPointMake(a.x + b.x, a.y + b.y)
}

func - (a:CGPoint, b:CGPoint) -> CGPoint {
    return CGPointMake(a.x - b.x, a.y - b.y)
}

func * (a:CGPoint, b:CGPoint) -> CGPoint {
    return CGPointMake(a.x * b.x, a.y * b.y)
}
