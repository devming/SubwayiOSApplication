//
//  StationInfo.swift
//  GaongilroMobile
//
//  Created by Minki on 2018. 8. 28..
//  Copyright © 2018년 devming. All rights reserved.
//

import Foundation

struct SubwayLine: Codable {
    var line1: [StationInfo]
    var line2: [StationInfo]
    var line3: [StationInfo]
    var line4: [StationInfo]
    var line5: [StationInfo]
    var line6: [StationInfo]
    var line7: [StationInfo]
    var line8: [StationInfo]
    var line9: [StationInfo]
    var lineA: [StationInfo]
    var lineB: [StationInfo]
    var lineE: [StationInfo]
    var lineG: [StationInfo]
    var lineI: [StationInfo]
    var lineI2: [StationInfo]
    var lineK: [StationInfo]
    var lineKK: [StationInfo]
    var lineS: [StationInfo]
    var lineSU: [StationInfo]
    var lineU: [StationInfo]
    
    enum CodingKeys: String, CodingKey {
        case line1 = "line1"
        case line2 = "line2"
        case line3 = "line3"
        case line4 = "line4"
        case line5 = "line5"
        case line6 = "line6"
        case line7 = "line7"
        case line8 = "line8"
        case line9 = "line9"
        case lineA = "lineA"
        case lineB = "lineB"
        case lineE = "lineE"
        case lineG = "lineG"
        case lineI = "lineI"
        case lineI2 = "lineI2"
        case lineK = "lineK"
        case lineKK = "lineKK"
        case lineS = "lineS"
        case lineSU = "lineSU"
        case lineU = "lineU"
    }
}

struct StationInfo: Codable {
    let stationCode: String
    let stationName: String
    let lineNumber: String
    let frCode: String
    let stationNameEnglish: String
    
    enum CodingKeys: String, CodingKey {
        case stationCode = "STATION_CD"
        case stationName = "STATION_NM"
        case lineNumber = "LINE_NUM"
        case frCode = "FR_CODE"
        case stationNameEnglish = "STATION_NM_ENG"
    }
}
