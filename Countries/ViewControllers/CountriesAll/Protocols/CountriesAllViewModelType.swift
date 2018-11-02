//
//  CountryAllViewModelType.swift
//  Countries
//
//  Created by Icandeliver on 02/11/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import RxSwift

protocol CountriesAllViewModelType {
    
    var errorObservable: Observable<String> { get }
    
    var countriesObservable: Observable<[CountriesAllTableViewModelType]> { get }
    
    var itemSelected: PublishSubject<IndexPath> { get }
    
}
