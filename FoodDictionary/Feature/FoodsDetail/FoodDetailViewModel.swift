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
    case tapSaveBtn(name: String, isSelected: Bool)
}

class FoodDetailViewModel: Stepper {
    let steps = PublishRelay<Step>()
    var disposeBag = DisposeBag()
    let foodDetailName: String
    let service: FoodService
    var foodData: [Food] = []
    
    var foodDetailRely = BehaviorRelay<Food?>(value: nil)
    
    struct Input {
        let trigger: PublishRelay<Void>
        let actionTrigger: Observable<FoodDetailActionType>
    }
    struct Output {
        let foodDetailRely: BehaviorRelay<Food?>
    }
    
    init(foodDetailName: String,
         service: FoodService) {
        self.foodDetailName = foodDetailName
        self.service = service
    }
    
    func transform(req: Input) -> Output {
        req.trigger
            .bind(onNext: { [weak self] _ in
                self?.setDetailData()
            })
            .disposed(by: disposeBag)
        
        req.actionTrigger
            .subscribe(onNext: {
                [weak self] action in
                self?.doAction(action)
            })
            .disposed(by: disposeBag)
        
        return Output(foodDetailRely: foodDetailRely)
    }
    
    func setDetailData() {
        service.newsRelay.bind { [weak self] data in
            guard !data.isEmpty else { return }
            self?.foodData = data
            if let foodDetail = data.first(where: { $0.RCP_NM == self?.foodDetailName}) {
                self?.foodDetailRely.accept(foodDetail)
            }
        }
        .disposed(by: disposeBag)
    }
}


extension FoodDetailViewModel {
    func doAction(_ actionType: FoodDetailActionType) {
        switch actionType {
        case .tapSaveBtn(let name, let isSelected):
            tapSaveBtn(name: name, isSelected: isSelected)
        }
    }
    
    func tapSaveBtn(name: String, isSelected: Bool){
        if let index = self.foodData.firstIndex(where: { $0.RCP_NM == name}) {
            self.foodData[index].RCP_SAVE = isSelected
            service.newsRelay.accept(self.foodData)
            if isSelected {
                CoreDataStorage.shared.insertFood(food: foodData[index])
                CoreDataStorage.shared.readFood()
            } else {
                CoreDataStorage.shared.deleteFood(name: foodData[index].RCP_NM)
            }
        }
    }
}
