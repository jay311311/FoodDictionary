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
    
    let rootViewController = UITabBarController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainSteps else { return .none }
        
        switch step {
        case .initialStep:
            return setupTabBar()
        default:
            return .none
        }
    }
    
    private func setupTabBar() -> FlowContributors {
        let foodListViewModel = FoodListViewModel()
        let favoritesViewModel = FavoritesViewModel()
        
        let foodListFlow = FoodListFlow(foodListViewModel: foodListViewModel)
        let favoritesFlow = FavoritesFlow(favoritesViewModel: favoritesViewModel)
        
        Flows.use(foodListFlow, favoritesFlow, when: .created) { [weak self] (root1: UINavigationController, root2: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: "FoodList", image: UIImage(systemName: "fork.knife.circle"), selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.circle"), selectedImage: nil)
            root1.tabBarItem = tabBarItem1
            root1.title = "FoodList"
            root2.tabBarItem = tabBarItem2
            root2.title = "Favorites"
            
            self?.rootViewController.setViewControllers([root1, root2], animated: false)
        }
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: foodListFlow, withNextStepper: OneStepper(withSingleStep: FoodListSteps.initialStep)),
            .contribute(withNextPresentable: favoritesFlow, withNextStepper: OneStepper(withSingleStep: FavoritesSteps.initialStep))
        ])
    }
}

class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    var initialStep: Step {
        return MainSteps.initialStep
    }
}
