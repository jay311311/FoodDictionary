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
    
    let service: FoodService = FoodService()
    
    let rootViewController: UITabBarController = {
        let tabBar = UITabBarController()
        tabBar.tabBar.backgroundColor = .white
        return tabBar
    }()
    
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
        let foodListViewModel = FoodListViewModel(service: service)
        let favoritesViewModel = FavoritesViewModel(service: service)
        
        let foodListFlow = FoodListFlow(foodListViewModel: foodListViewModel, service: service)
        let favoritesFlow = FavoritesFlow(favoritesViewModel: favoritesViewModel, service: service)
        
        Flows.use(foodListFlow, favoritesFlow, when: .created) { [weak self] (root1: UINavigationController, root2: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: "Recipe", image: UIImage(systemName: "fork.knife.circle"), selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.circle"), selectedImage: nil)
            root1.tabBarItem = tabBarItem1
            root1.tabBarItem.title = "Recipe"
            root2.tabBarItem = tabBarItem2
            root2.tabBarItem.title = "Favorites"
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
