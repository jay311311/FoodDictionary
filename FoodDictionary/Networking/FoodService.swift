//
//  FoodService.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class FoodService {
    static let shared = FoodService()
    
    func getFoodListByMoya() -> Single<[Food]> {
        let request =  Single<[Food]>.create { observer in
            
            let moyaProvider = MoyaProvider<FoodMoaya>()
            
            let task = moyaProvider.request(.food) { (result) in
                switch result {
                case let .success(response):
                    guard let data = try? response.map(FoodModel.self) else { return }
                    observer(.success(data.COOKRCP01.row))
                case let .failure(error):
                    print(error.localizedDescription)
                    observer(.failure(error))
                }
                
            }
            return Disposables.create { task.cancel() }
        }.observe(on: MainScheduler.instance)
        return request
    }
}
