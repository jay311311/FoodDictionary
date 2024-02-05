//
//  FavoritesViewModel.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/07.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

class FavoritesViewModel: Stepper {
    let steps = PublishRelay<Step>()
    
    let service: FoodService

    init(service: FoodService) {
        self.service = service
    }
}
