//
//  Int.swift
//  Countries
//
//  Created by Icandeliver on 31/10/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import Foundation

extension Int {
    var asPeople: String {
        let number = NSNumber(value: self)
        return (Formatter.withSeparator.string(from: number) ?? "\(self)") + " people"
    }
}
