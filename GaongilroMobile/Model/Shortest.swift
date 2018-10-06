//
//  Shortest.swift
//  GaongilroMobile
//
//  Created by Minki on 2018. 6. 11..
//  Copyright © 2018년 devming. All rights reserved.
//

import Foundation

enum Direction: String {
    case NONE
    case LEFT
    case RIGHT
}

struct Shortest {
    let startStation: String
    let direction: Direction
}

struct ToiletShortest {
    let toiletNumber: Int
    let direction: Direction
}
