//
//  FoodService.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import Foundation
import Moya

class FoodService {
    
    func getFoodListByMoya() {
        let moyaProvider = MoyaProvider<FoodMoaya>()
        moyaProvider.request(.food) { (result) in
            switch result {
            case let .success(response):
                guard let result = try? response.map(FoodModel.self) else { return }
                print("여기여기 \(result)")
                DispatchQueue.main.async {
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
  }
