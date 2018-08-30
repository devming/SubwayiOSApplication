//
//  SubwayManager.swift
//  GaongilroMobile
//
//  Created by Minki on 2018. 8. 29..
//  Copyright © 2018년 devming. All rights reserved.
//

import Foundation

final class SubwayManager {
    static var shared = SubwayManager()
    var lines: SubwayLine?
    var filteredLines: SubwayLine?
    
//    var linesNew: [[String : [StationInfo]]]?
//    var filteredLinesNew: [[String : [StationInfo]]]?
    
    var currentDestination: StationInfo?
    
    lazy var totalCount: Int = {
        guard let info = self.lines else {
            return 0
        }
        return info.line1.count + info.line2.count + info.line3.count + info.line4.count
            + info.line5.count + info.line6.count + info.line7.count + info.line8.count
            + info.line9.count + info.lineA.count + info.lineB.count + info.lineE.count
            + info.lineG.count + info.lineI.count + info.lineI2.count + info.lineK.count
            + info.lineKK.count + info.lineS.count + info.lineSU.count + info.lineU.count
    }()
    
    lazy var filteredCount: Int = {
        guard let info = self.filteredLines else {
            return 0
        }
        return info.line1.count + info.line2.count + info.line3.count + info.line4.count
            + info.line5.count + info.line6.count + info.line7.count + info.line8.count
            + info.line9.count + info.lineA.count + info.lineB.count + info.lineE.count
            + info.lineG.count + info.lineI.count + info.lineI2.count + info.lineK.count
            + info.lineKK.count + info.lineS.count + info.lineSU.count + info.lineU.count
    }()
    
//    func setDatas() {
//        guard let linesDictionary = SubwayManager.shared.linesNew else {//, let selectedDataLine1 = linesDictionary[indexPath.row][SubwayLine.CodingKeys.line1.rawValue]
//            return
//        }
//        let lines = linesDictionary[indexPath.row]
//        var stationName = "\(line.value[indexPath.row].stationName)"
//        for line in lines {
//            switch line.key {
//            case SubwayLine.CodingKeys.line1.rawValue:
//                currentDestination = line.value[indexPath.row]
//            case SubwayLine.CodingKeys.line2.rawValue:
//                currentDestination = line.value[indexPath.row]
//            default:
//                break
//            }
//        }
//    }
}
