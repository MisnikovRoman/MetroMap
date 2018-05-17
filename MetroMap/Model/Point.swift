//
//  Point.swift
//  test-wave-algoritm
//
//  Created by Роман Мисников on 09.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import Foundation

// coordinate point
struct Point: CustomStringConvertible, Comparable {
    
    
    var x,y: Int
    
    // соответствие стандартному протоколу
    var description: String {
        get {
            return "(x: \(x), y: \(y))"
        }
    }
    
    static func < (lhs: Point, rhs: Point) -> Bool {
        return (lhs.x < rhs.x) && (lhs.y < rhs.y)
    }
    static func == (lhs: Point, rhs: Point) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
    }

}
