//
//  FavoritesFlow.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

class FavoritesFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController = UINavigationController()
    private let favoritesViewModel: FavoritesViewModel
    var service: FoodService
    
    init(favoritesViewModel: FavoritesViewModel,
         service: FoodService) {
        self.favoritesViewModel = favoritesViewModel
        self.service = service
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FavoritesSteps else { return .none }
        
        switch step {
        case .initialStep:
            return navigateToFavoritesScreen()
        case .foodDetail:
            return navigateToFoodDetail()
        default:
            return .none
        }
    }
    
    private func navigateToFoodDetail() -> FlowContributors {
        return .none
    }
    
    private func navigateToFavoritesScreen() -> FlowContributors {
        let viewController = FavoritesViewController()
        viewController.viewModel = self.favoritesViewModel
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))
    }
}
