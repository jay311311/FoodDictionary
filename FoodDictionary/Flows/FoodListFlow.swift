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
    
    private let rootViewController = UINavigationController()
    private let service: FoodService
    private let foodListStepper: FoodListStepper


    init(service: FoodService, foodListStepper: FoodListStepper) {
        self.service = service
        self.foodListStepper = foodListStepper
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? Steps else { return .none }
        switch step {
        case .foodList:
            return navigateToFoodListScreen()
        case .foodDetail:
            return navigateToFoodDetailScreen()
        default:
            return .none
        }

    }
    
    private func navigateToFoodListScreen() -> FlowContributors {
        let viewController = FoodListViewController()
        let stepper = FoodListStepper()
        service.getFoodListByMoya()
        viewController.title = "FoodList"
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: stepper))
    }
    
    private func navigateToFoodDetailScreen() -> FlowContributors {
        return .none
    }


}

class FoodListStepper: Stepper {

    let steps = PublishRelay<Step>()

    @objc func foodListRequire() {
        self.steps.accept(Steps.foodList)
    }
}
