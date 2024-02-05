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
    case tapFoodList(name: String)
    case tapSaveBtn(name: String, isSelected: Bool)
}

class FoodListViewModel: Stepper {
    let steps = PublishRelay<Step>()
    var disposeBag = DisposeBag()
    let service: FoodService
    
    var foodList = BehaviorRelay<[Food]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: true)
    
    init(service: FoodService) {
        self.service = service
    }
    
    struct Input {
        let requestTrigger: PublishRelay<Void>
        let refreshTrigger: PublishRelay<Void>
        let actionTrigger: Observable<FoodListActionType>
    }
    struct Output {
        let foodList: BehaviorRelay<[Food]>
        let isLoading: BehaviorRelay<Bool>
    }
    
    func transform(req: Input) -> Output {
        req.requestTrigger
            .bind(onNext: { [weak self] _ in
                self?.getData()
            })
            .disposed(by: disposeBag)
        
        req.refreshTrigger
            .bind(onNext: { [weak self] _ in
                self?.refreshData()
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
        service.getFoodListByMoya()
            .subscribe(onSuccess: { [weak self] data in
                self?.foodList.accept(data)
                self?.isLoading.accept(false)
            }).disposed(by: disposeBag)
    }

    private func refreshData() {
        self.foodList.accept(service.foodData)
    }
}

extension FoodListViewModel {
    private func doAction(_ actionType: FoodListActionType) {
        switch actionType {
        case .tapFoodList(let name):
            return tapFoodList(name: name)
        case .tapSaveBtn(let name, let isSelected):
            return tapSaveBtn(name: name, isSelected: isSelected)
        }
    }
    
    func tapFoodList(name: String) {
        self.steps.accept(FoodListSteps.foodDetail(name: name))
    }
    
    func tapSaveBtn(name: String, isSelected: Bool) {
        if let index = self.service.foodData.firstIndex(where: { $0.RCP_NM == name}) {
            self.service.foodData[index].RCP_SAVE = isSelected
            self.foodList.accept(self.service.foodData)
//            CoreDataStorage.shared.insert(food: foodData[index])
        }
    }
}
