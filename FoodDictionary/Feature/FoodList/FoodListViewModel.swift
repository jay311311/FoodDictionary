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

enum ListActionType {
    case tapFoodList(name: String)
    case tapSaveBtn(name: String, isSelected: Bool)
    case changeKeyWorod(word: String)
}

class FoodListViewModel: Stepper {
    let steps = PublishRelay<Step>()
    var disposeBag = DisposeBag()
    let service: FoodService
    
    var foodList = BehaviorRelay<[Food]>(value: [])
    var foodData:[Food] =  []
    var isLoading = BehaviorRelay<Bool>(value: true)
    
    init(service: FoodService) {
        self.service = service
    }
    
    struct Input {
        let requestTrigger: PublishRelay<Void>
        let actionTrigger: Observable<ListActionType>
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
        service.newsRelay.bind { [weak self] data in
            guard !data.isEmpty else { return }
            self?.isLoading.accept(false)
            self?.foodData = data
            self?.foodList.accept(data)
        }
        .disposed(by: disposeBag)
    }
}

extension FoodListViewModel {
    private func doAction(_ actionType: ListActionType) {
        switch actionType {
        case .tapFoodList(let name):
            return tapFoodList(name: name)
        case .tapSaveBtn(let name, let isSelected):
            return tapSaveBtn(name: name, isSelected: isSelected)
        case .changeKeyWorod(let word):
            return changeKeyWorod(word: word)
        }
    }
    
    func tapFoodList(name: String) {
        self.steps.accept(FoodListSteps.foodDetail(name: name))
    }
    
    func tapSaveBtn(name: String, isSelected: Bool) {
        if let index = self.foodData.firstIndex(where: { $0.RCP_NM == name}) {
            self.foodData[index].RCP_SAVE = isSelected
            self.service.newsRelay.accept(self.foodData)
            self.foodList.accept(self.foodData)
            if isSelected {
                CoreDataStorage.shared.insertFood(food: foodData[index])
                CoreDataStorage.shared.readFood()
                
            } else {
                CoreDataStorage.shared.deleteFood(name: foodData[index].RCP_NM)
            }
        }
    }
    
    func changeKeyWorod(word: String) {
        if word == "" {
            let originData = service.newsRelay.value
            foodList.accept(originData)
        } else {
            let filteredData = foodData.filter { $0.RCP_NM.contains(word)}
            foodList.accept(filteredData)
        }
    }
}
