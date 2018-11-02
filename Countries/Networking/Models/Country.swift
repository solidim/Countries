//
//  Country.swift
//  Countries
//
//  Created by Icandeliver on 31/10/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import ObjectMapper

struct Country: Mappable {
    
    var name: String?
    var population: Int?
    var code: String?

    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        population <- map["population"]
        code <- map["alpha3Code"]
    }
    
}
