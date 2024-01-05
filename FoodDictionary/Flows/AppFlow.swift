//
//  AppFlow.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

class AppFlow: Flow {
    var root: Presentable {
            return self.rootViewController
        }
    
    private let rootViewController = UITabBarController()
    private let service: FoodService

    init(withService service: FoodService) {
        self.service = service
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? Steps else { return .none }
        
        switch step {
        case .foodList:
            return navigateToFoodListScreen()
        default:
            return .none
        }
    }
    
    private func navigateToFoodListScreen() -> FlowContributors {
        let foodListStepper = FoodListStepper()
        let favoritesStepper = FavoritesStepper()

        let foodListFlow = FoodListFlow(service: self.service, foodListStepper: foodListStepper)
        let favoritesFlow = FavoritesFlow(service: self.service, favoritesStepper: favoritesStepper)
        Flows.use(foodListFlow, favoritesFlow, when: .created) { [unowned self] (root1: UINavigationController, root2: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: "FoodList", image: UIImage(systemName: "fork.knife.circle"), selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.circle"), selectedImage: nil)
            root1.tabBarItem = tabBarItem1
            root1.title = "FoodList"
            root2.tabBarItem = tabBarItem2
            root2.title = "Favorites"

            self.rootViewController.setViewControllers([root1, root2], animated: false)
        }

        return .multiple(flowContributors: [.contribute(withNextPresentable: foodListFlow,
                                                        withNextStepper: CompositeStepper(steppers: [OneStepper(withSingleStep: Steps.foodList), foodListStepper])),
                                            .contribute(withNextPresentable: favoritesFlow,
                                                        withNextStepper: CompositeStepper(steppers: [OneStepper(withSingleStep: Steps.favorites), favoritesStepper]))])
    }
}

class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    private let appService: FoodService
    
    init(withService service: FoodService) {
        self.appService = service
    }
    
    var initialStep: Step {
        return Steps.foodList
    }
}
