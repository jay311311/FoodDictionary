//
//  Steps.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import Foundation
import RxFlow

enum MainSteps: Step {
    case initialStep
}

enum FoodListSteps: Step {
    case initialStep
    case foodDetail(food: Food)
}

enum FavoritesSteps: Step {
    case initialStep
    case foodDetail(food: Food)
}
