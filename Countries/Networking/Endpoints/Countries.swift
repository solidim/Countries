//
//  DataService.swift
//  Countries
//
//  Created by Icandeliver on 31/10/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import Moya

enum Countries {
    case all
    case name(countryName: String)
}

extension Countries: TargetType {
    var baseURL: URL { return URL(string: "https://restcountries.eu/rest/v2")! }
    var path: String {
        switch self {
        case .all:
            return "/all"
        case .name(let countryName):
            return "/name/\(countryName)"
        }
    }
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        switch self {
        case .all:
            return .requestParameters(parameters: ["fields": "name;population;alpha3Code"], encoding: URLEncoding.queryString)
        case .name(_):
            return .requestParameters(parameters: ["fields": "name;population;capital;borders;currencies"], encoding: URLEncoding.queryString)
        }
    }
    var sampleData: Data {
        var resource: String
        switch self {
        case .all:
            resource = "all"
        case .name(_):
            resource = "name"
        }
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        return data
    }
    var headers: [String: String]? { return nil }
}

extension Countries: CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringCacheData
    }
}


