//
//  Refresher.swift
//  Countries
//
//  Created by Icandeliver on 01/11/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import UIKit

final class Refresher: UIRefreshControl {
    
    override init() {
        super.init()
        setupRefresher()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupRefresher()
    }
    
    private func setupRefresher() {
        backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        tintColor = UIColor.darkGray
        attributedTitle = NSAttributedString(string: "Pull to refresh")
    }
    
}
