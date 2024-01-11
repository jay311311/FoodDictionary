//
//  FoodListViewModel.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/07.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow


class FoodListViewModel: Stepper {
    let steps = PublishRelay<Step>()
    var disposeBag = DisposeBag()

    var initialStep: Step {
        return FoodListSteps.initialStep
    }
    var foodList = BehaviorRelay<[Food]>(value: [])
    
    
    func getData()  {
        FoodService.shared
            .getFoodListByMoya()
            .subscribe(onSuccess: { data in
                print("연동 \(data)")
                self.foodList.accept(data)
            }).disposed(by: disposeBag)
    }
}
