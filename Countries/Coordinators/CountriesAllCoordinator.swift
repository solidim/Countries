//
//  CountriesAllCoordinator.swift
//  Countries
//
//  Created by Icandeliver on 01/11/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import RxSwift

final class CountriesAllCoordinator: Coordinator {
  
    var countrySelected = PublishSubject<(Country, [Country])>()
    let disposeBag = DisposeBag()
    
    override init(navigationController: UINavigationController?) {
        super.init(navigationController: navigationController)
        
        countrySelected
            .subscribe(onNext: { inputData in
                let viewModel = CountryItemViewModel(inputData: inputData)
                let viewController = CountryItemViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func start() {
        let viewModel = CountriesAllViewModel()
        let viewController = CountriesAllViewController(viewModel: viewModel)
        
        viewModel.countrySelected.asObservable()
            .bind(to: countrySelected)
            .disposed(by: disposeBag)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
