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

enum FoodListActionType {
    case tapFoodList(food: Food)
    case tapSaveBtn(name: String, isSelected: Bool)
}

class FoodListViewModel: Stepper {
    let steps = PublishRelay<Step>()
    var disposeBag = DisposeBag()
    
    var foodList = BehaviorRelay<[Food]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: true)
    var foodData: [Food] = []
    
    struct Input {
        let trigger: PublishRelay<Void>
        let actionTrigger: Observable<FoodListActionType>
    }
    struct Output {
        let foodList: BehaviorRelay<[Food]>
        let isLoading: BehaviorRelay<Bool>
    }
    
    func transform(req: Input) -> Output {
        req.trigger
            .bind(onNext: { [weak self] _ in
                self?.getData()
            })
            .disposed(by: disposeBag)
        
        req.actionTrigger
            .subscribe(onNext: {
                [weak self] action in
                self?.doAction(action)
            })
            .disposed(by: disposeBag)
        
        return Output(
            foodList: foodList,
            isLoading: isLoading
        )
    }
    
    private func getData() {
        FoodService.shared
            .getFoodListByMoya()
            .subscribe(onSuccess: { [weak self] data in
                self?.foodList.accept(data)
                self?.foodData = data
                self?.isLoading.accept(false)
            }).disposed(by: disposeBag)
    }
}

extension FoodListViewModel {
    private func doAction(_ actionType: FoodListActionType) {
        switch actionType {
        case .tapFoodList(let food):
            return tapFoodList(food: food)
        case .tapSaveBtn(let name, let isSelected):
            return tapSaveBtn(name: name, isSelected: isSelected)
        }
    }
    
    func tapFoodList(food: Food) {
        self.steps.accept(FoodListSteps.foodDetail(food: food))
    }
    
    func tapSaveBtn(name: String, isSelected: Bool) {
        if let index = self.foodData.firstIndex(where: { $0.RCP_NM == name}) {
            self.foodData[index].RCP_SAVE = isSelected
            self.foodList.accept(self.foodData)
            
        }
    }
}
