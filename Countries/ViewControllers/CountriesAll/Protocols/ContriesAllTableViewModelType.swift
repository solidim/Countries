//
//  ContriesTableViewModelType.swift
//  Countries
//
//  Created by Icandeliver on 02/11/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import RxSwift

protocol CountriesAllTableViewModelType {
    
    var name: Observable<String> { get }
    
    var population: Observable<String> { get }
    
}

