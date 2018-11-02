//
//  CountryItem.swift
//  Countries
//
//  Created by Icandeliver on 31/10/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import ObjectMapper

struct CountryItem: Mappable {
    
    var name: String?
    var capital: String?
    var population: Int?
    var currencies: [Currency]?
    var borders: [String]?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        capital <- map["capital"]
        population <- map["population"]
        currencies <- map["currencies"]
        borders <- map["borders"]
    }
    
}
