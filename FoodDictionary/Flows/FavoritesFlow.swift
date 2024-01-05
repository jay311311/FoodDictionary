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
    
    private let rootViewController = UINavigationController()
    private let service: FoodService
    private let favoritesStepper: FavoritesStepper


    init(service: FoodService, favoritesStepper: FavoritesStepper) {
        self.service = service
        self.favoritesStepper = favoritesStepper
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? Steps else { return .none }
        
        switch step {
        case .favorites:
            return navigateToFavoritesScreen()
        case .foodDetail:
            return navigateToFoodDetailScreen()
        default:
            return .none
        }

    }
    
    
    private func navigateToFoodDetailScreen() -> FlowContributors {
        return .none
    }

    private func navigateToFavoritesScreen() -> FlowContributors {
        let viewController = FavoritesViewController()
        let stepper = FavoritesStepper()
               viewController.title = "Favorite"
               self.rootViewController.pushViewController(viewController, animated: true)
               return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: stepper))
    }

}


class FavoritesStepper: Stepper {

    let steps = PublishRelay<Step>()

    @objc func favoritesRequire() {
        self.steps.accept(Steps.favorites)
    }
}
