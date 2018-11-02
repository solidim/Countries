//
//  CountriesAllTableViewModel.swift
//  Countries
//
//  Created by Icandeliver on 02/11/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import RxSwift

final class CountriesAllTableViewModel: CountriesAllTableViewModelType {
    
    let name: Observable<String>
    let population: Observable<String>
    
    init(country: Country) {
        name = .just(country.name ?? "-")
        population = .just(country.population?.asPeople ?? "-")
    }
    
}
