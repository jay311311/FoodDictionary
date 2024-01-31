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
        case .foodDetail(let food):
            return navigateToFoodDetail(food: food)
        default:
            return .none
        }
    }
    
    private func navigateToFoodListScreen() -> FlowContributors {
        let viewController = FoodListViewController()
        viewController.viewModel = self.foodListViewModel
        rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel, allowStepWhenDismissed: true))
    }
    
    private func navigateToFoodDetail(food: Food) -> FlowContributors {
        let viewController =  FoodDetailViewController()
        viewController.viewModel = FoodDetailViewModel(foodDetail: food)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: false)
        return .none
    }
}


