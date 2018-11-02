//
//  AppCoordinator.swift
//  Countries
//
//  Created by Icandeliver on 01/11/2018.
//  Copyright © 2018 DS. All rights reserved.
//

final class AppCoordinator: Coordinator {
    
    func start() {
        let coordinator = CountriesAllCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func countriesAllCoordinatorCompleted(coordinator: CountriesAllCoordinator) {
        if let index = childCoordinators.index(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
