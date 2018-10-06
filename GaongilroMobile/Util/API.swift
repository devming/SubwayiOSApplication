//
//  API.swift
//  GaongilroMobile
//
//  Created by Minki on 2018. 1. 16..
//  Copyright © 2018년 devming. All rights reserved.
//

import Foundation

protocol API {

    func getSubwayDirection(stationName: String)
    func getToiletDirection()
}

//struct APIService: API {
//    func getSubwayDirection(stationName: String) {
//        <#code#>
//    }
//
//    func getToiletDirection() {
//        <#code#>
//    }
//
//}

enum APIRouter {
    case getSubwayDirection(stationName: String)
    case getToiletDirection()
}

//extension APIRouter: URLRequestConvertible {
//    static let baseURLString: String = "http://ec2-52-79-233-2.ap-northeast-2.compute.amazonaws.com:8080/OhJooYeoMVC"
//    static let manager: Alamofire.SessionManager = {
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 30 // seconds
//        configuration.timeoutIntervalForResource = 30
//        configuration.httpCookieStorage = HTTPCookieStorage.shared
//        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
//        let manager = Alamofire.SessionManager(configuration: configuration)
//        return manager
//    }()
//
//    var method: HTTPMethod {
//        switch self {
//        case .getWorshipIdList:
//            return .get
//        case .getRecentDatas:
//            return .post
//        case .getPharseMessages:
//            return .post
//        }
//    }
//
//    var path: String {
//        switch self {
//        case .getWorshipIdList():
//            return "/worship-list"
//        case let .getRecentDatas(worshipId, version, _):
//            return "/worship-id/\(worshipId)/check/version/\(version)"
//        case .getPharseMessages(_, _):
//            return "/phrase"
//        }
//    }
//
//    func asURLRequest() throws -> URLRequest {
//        let url = try APIRouter.baseURLString.asURL()
//
//        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
//        urlRequest.httpMethod = method.rawValue
//        urlRequest.addValue("Content-Type", forHTTPHeaderField: "application/json;charset=UTF-8")
//
//        switch self {
//        case .getWorshipIdList():
//            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
//        case let .getRecentDatas(_, _, parameters):
//            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
//        case let .getPharseMessages(_, parameters):
//            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
//        }
//
//        return urlRequest
//    }
//}
