//
//  FoodDetailViewModel.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/07.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

class FoodDetailViewModel: Stepper {
    let steps = PublishRelay<Step>()

}
