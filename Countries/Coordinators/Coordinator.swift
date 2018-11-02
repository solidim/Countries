//
//  Coordinator.swift
//  Countries
//
//  Created by Icandeliver on 02/11/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}
