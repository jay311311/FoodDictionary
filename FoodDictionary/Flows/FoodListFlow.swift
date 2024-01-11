//
//  FoodListFlow.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

class FoodListFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController = UINavigationController()
    private let foodListViewModel: FoodListViewModel
    
    
    init(foodListViewModel: FoodListViewModel) {
        self.foodListViewModel = foodListViewModel
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FoodListSteps else { return .none }
        switch step {
        case .initialStep:
            return navigateToFoodListScreen()
        case .foodDetail:
            return navigateToFoodDetailScreen()
        default:
            return .none
        }
    }
    
    private func navigateToFoodListScreen() -> FlowContributors {
        let viewController = FoodListViewController()
        viewController.viewModel = self.foodListViewModel
        rootViewController.pushViewController(viewController, animated: true)
        return .none
    }
    
    private func navigateToFoodDetailScreen() -> FlowContributors {
        return .none
    }
}


