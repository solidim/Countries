//
//  CountriesAllViewModel.swift
//  Countries
//
//  Created by Icandeliver on 01/11/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Moya_ObjectMapper
import Reachability

class CountriesAllViewModel {
    
    private let error = PublishSubject<String>()
    private let countries = Variable<[(Country, CountriesAllTableViewModelType)]>([])
    private var countriesAll = [Country]()
    private let provider = MoyaProvider<Countries>(plugins: [CachePolicyPlugin()])

    let disposeBag = DisposeBag()
    
    var countrySelected = PublishSubject<(Country, [Country])>()
    let itemSelected = PublishSubject<IndexPath>()
    
    let reachability = Reachability()!

    lazy var errorObservable: Observable<String> = self.error.asObservable()
    lazy var countriesObservable: Observable<[CountriesAllTableViewModelType]> = self.countries.asObservable().map { $0.map { $0.1 } }
    
    /// For every request
    private let _loaded = BehaviorSubject<Bool>(value: false)
    lazy var loaded = _loaded.asObservable()
    
    /// Only once
    public var dataReceived = BehaviorSubject<Bool>(value: false)
    
    let reload: AnyObserver<Bool>

    init() {
        let _reload = PublishSubject<Bool>()
        self.reload = _reload.asObserver()
        
        itemSelected
            .map { [weak self] in self?.countries.value[$0.row] }
            .subscribe(onNext: { [weak self] country in
                guard let `self` = self, let country = country else { return }
                if self.reachability.connection != .none {
                    `self`.countrySelected
                        .onNext((country.0, self.countriesAll))
                } else {
                    self.error.onNext(CountriesError.connection.rawValue)
                }
            })
            .disposed(by: disposeBag)
        
        _reload.subscribe(onNext: { _ in
            self.downloadCountries()
        }).disposed(by: disposeBag)
        
        reachability.whenUnreachable = { [weak self] _ in
            self?.error.onNext(CountriesError.connection.rawValue)
        }
        
        reachability.whenReachable = { [weak self] reachability in
            do {
                /// Reload only if no data in table
                if try self?.dataReceived.value() == false {
                    self?.reload.onNext(true)
                }
            } catch {
                self?.error.onNext(CountriesError.connection.rawValue)
            }
        }

        do {
            try reachability.startNotifier()
        } catch {
            self.error.onNext(CountriesError.connection.rawValue)
        }
    }
    
    func downloadCountries() {
        _loaded.onNext(false)
        provider.request(.all) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(response):
                do {
                    let countries = try response.mapArray(Country.self)
                    self.countriesAll = countries
                    self.countries.value = countries.map { ($0, CountriesAllTableViewModel(country: $0)) }
                    self.dataReceived.onNext(true)
                    self._loaded.onNext(true)
                } catch {
                    self.error.onNext(CountriesError.unknown.rawValue)
                }
            case .failure:
                self.error.onNext(CountriesError.connection.rawValue)
            }
        }
    }
    
    deinit {
        reachability.stopNotifier()
    }

}
