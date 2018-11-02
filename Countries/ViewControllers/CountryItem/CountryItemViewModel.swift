//
//  CountryItemViewModel.swift
//  Countries
//
//  Created by Icandeliver on 01/11/2018.
//  Copyright © 2018 DS. All rights reserved.
//
import RxSwift
import Moya

final class CountryItemViewModel {
   
    let countryName = BehaviorSubject<String?>(value: "")

    private let provider = MoyaProvider<Countries>(plugins: [CachePolicyPlugin()])
    
    private let countryItemsObserer = Variable<(CountryItem, [Country])?>(nil)
    lazy var countryItemsObservable = self.countryItemsObserer.asObservable()

    private let countryDetailsObserver = Variable<[(header: String, desc: String)]>([])
    lazy var countryDetailsObservable = self.countryDetailsObserver.asObservable()
    
    private let error = PublishSubject<String>()
    lazy var errorObservable = error.asObservable()
    
    private let _loaded = BehaviorSubject<Bool>(value: false)
    lazy var loaded = _loaded.asObservable()
    
    private let _countryName: String
    private let _allCountries: [Country]

    init(inputData: (Country, [Country])) {
        countryName.onNext(inputData.0.name)
        _countryName = inputData.0.name!
        _allCountries = inputData.1
        
        downloadDetails()
    }
    
    private func downloadDetails() {
        _loaded.onNext(false)
        provider.request(.name(countryName: _countryName)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(response):
                do {
                    let items = try response.mapArray(CountryItem.self)
                    if let item = items.first {
                        self.countryDetailsObserver.value = self.buildData(country: item)
                        self._loaded.onNext(true)
                    } else {
                        self.error.onNext(CountriesError.unknown.rawValue)
                    }
                } catch {
                    self.error.onNext(CountriesError.unknown.rawValue)
                }
            case .failure:
                self.error.onNext(CountriesError.connection.rawValue)
            }
        }
    }
    
    private func buildData(country: CountryItem) -> [(header: String, desc: String)] {
        var result = [(header: String, desc: String)]()
        if let name = country.name, !name.isEmpty {
            result.append((header: "Country name", desc: name))
        }
        if let capital = country.capital, !capital.isEmpty {
            result.append((header: "Capital", desc: capital))
        }
        if country.population != nil {
            result.append((header: "Population", desc: country.population!.asPeople))
        }
        if let borders = country.borders, borders.count > 0 {
            let borderCountries = _allCountries
                .filter { $0.name != nil && $0.code != nil && borders.contains($0.code!) }
                .map { $0.name! }.joined(separator: ", ")
            result.append((header: "Common border with", desc: borderCountries))
        }
        if let currencies = country.currencies, currencies.count > 0 {
            result.append((header: "Currencies", desc: currencies.compactMap { $0.name }.joined(separator: ", ")))
        }
        return result
    }
    
    
}
