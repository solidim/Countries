//
//  Currency.swift
//  Countries
//
//  Created by Icandeliver on 31/10/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import ObjectMapper

struct Currency: Mappable {
    
    var code: String?
    var name: String?    
    var symbol: String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        name <- map["name"]
        symbol <- map["symbol"]
    }
 
}
