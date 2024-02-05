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
    var disposeBag = DisposeBag()
    
    var foodList = BehaviorRelay<[Food]>(value: [])
    
    init(service: FoodService) {
        self.service = service
    }
    
    struct Input {
        let requestTrigger: PublishRelay<Void>
        let actionTrigger: Observable<ListActionType>
    }
    struct Output {
        let foodList: BehaviorRelay<[Food]>
    }
    
    func transform(req: Input) -> Output {
        req.requestTrigger
            .bind(onNext: { [weak self] _ in
                self?.getDataFromCoreData()
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
            foodList: foodList
        )
    }
    
    func getData() {
        
        CoreDataStorage.shared.savedListSubject
            .bind(onNext: { [weak self] data in
                self?.foodList.accept(data)
            })
            .disposed(by: disposeBag)
    }
    
    func getDataFromCoreData() {
        CoreDataStorage.shared.readFood()
        
    }
}

extension FavoritesViewModel {
    private func doAction(_ actionType: ListActionType) {
        switch actionType {
        case .tapFoodList(let name):
            return tapFoodList(name: name)
        case .tapSaveBtn(let name, let isSelected):
            return tapSaveBtn(name: name, isSelected: isSelected)
        }
    }
    
    func tapFoodList(name: String) {
        self.steps.accept(FavoritesSteps.foodDetail(name: name))
    }
    
    func tapSaveBtn(name: String, isSelected: Bool) {
        var serviceData = self.service.newsRelay.value
        
        let newSaveData = serviceData.filter({$0.RCP_NM != name})
        self.foodList.accept(newSaveData)
        
        if let index = serviceData.firstIndex(where: { $0.RCP_NM == name}){
            serviceData[index].RCP_SAVE = false
            self.service.newsRelay.accept(serviceData)
            
        }
        
        if !isSelected {
            CoreDataStorage.shared.deleteFood(name: name)
        }
        
    }
}
