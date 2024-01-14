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
    var isLoading = BehaviorRelay<Bool>(value: true)
    
    struct Input {
        let trigger: PublishRelay<Void>
    }
    struct Output {
        let foodList: BehaviorRelay<[Food]>
        let isLoading: BehaviorRelay<Bool>
    }

    func transform(req: Input) -> Output {
        req.trigger
            .bind(onNext: { [weak self] _ in
                self?.getData()
            }).disposed(by: disposeBag)

        return Output(
            foodList: foodList,
            isLoading: isLoading
        )
    }
    
    func getData() {
        FoodService.shared
            .getFoodListByMoya()
            .subscribe(onSuccess: { data in
                self.foodList.accept(data)
                self.isLoading.accept(false)
            }).disposed(by: disposeBag)
    }
}
