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
    var originsFoodData:[Food] =  []
    var filteredFoodData:[Food] =  []
    
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
            guard let self = self  else { return }
            self.isLoading.accept(false)
            self.originsFoodData = data
            if !self.filteredFoodData.isEmpty {
                let serviceData = service.newsRelay.value
                let changedData = serviceData.filter{self.filteredFoodData.contains($0)}
                for item in changedData {
                    if let index = filteredFoodData.firstIndex(of: item){
                        filteredFoodData[index].RCP_SAVE = item.RCP_SAVE
                    }
                }
                self.foodList.accept(self.filteredFoodData)
            } else {
                self.foodList.accept(data)
            }
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
        let indexForOrigin = originsFoodData.firstIndex(where: { $0.RCP_NM == name})
        guard let indexForOrigin  = indexForOrigin else {return}
        
        if filteredFoodData.isEmpty {
            self.originsFoodData[indexForOrigin].RCP_SAVE = isSelected
            self.foodList.accept(self.originsFoodData)
            self.service.newsRelay.accept(self.originsFoodData)
        } else {
            if let index = filteredFoodData.firstIndex(where: { $0.RCP_NM == name}) {
                self.filteredFoodData[index].RCP_SAVE = isSelected
                self.foodList.accept(self.filteredFoodData)
                self.originsFoodData[indexForOrigin] = filteredFoodData[index]
                self.service.newsRelay.accept(self.originsFoodData)
            }
        }
        
        if isSelected {
            CoreDataStorage.shared.insertFood(food: originsFoodData[indexForOrigin])
            CoreDataStorage.shared.readFood()
        } else {
            CoreDataStorage.shared.deleteFood(name: originsFoodData[indexForOrigin].RCP_NM)
        }
    }
    
    func changeKeyWorod(word: String) {
        if word == "" {
            let originData = service.newsRelay.value
            foodList.accept(originData)
            filteredFoodData = []
        } else {
            let filteredData = originsFoodData.filter { $0.RCP_NM.contains(word)}
            filteredFoodData = filteredData
            foodList.accept(filteredData)
        }
    }
}
