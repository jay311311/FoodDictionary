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

enum FoodDetailActionType {
    case tapSaveBtn
}

class FoodDetailViewModel: Stepper {
    let steps = PublishRelay<Step>()
    var disposeBag = DisposeBag()
    let foodDetail: Food
    
    var foodDetailRely = BehaviorRelay<Food?>(value: nil)
    
    struct Input {
        let trigger: PublishRelay<Void>
        let actionTrigger: Observable<FoodDetailActionType>
    }
    struct Output {
        let foodDetailRely: BehaviorRelay<Food?>
    }
    
    init(foodDetail: Food) {
        self.foodDetail = foodDetail
    }
    
    func transform(req: Input) -> Output {
        req.trigger
            .bind(onNext: { [weak self] _ in
                self?.setDetailData()
            }).disposed(by: disposeBag)
        
        req.actionTrigger
            .subscribe(onNext: {
                [weak self] action in
                self?.doAction(action)
            })
            .disposed(by: disposeBag)
        
        return Output(foodDetailRely: foodDetailRely)
    }
    
    func setDetailData() {
        self.foodDetailRely.accept(self.foodDetail)
    }
    
}


extension FoodDetailViewModel {
    func doAction(_ actionType: FoodDetailActionType) {
        
    }
}
