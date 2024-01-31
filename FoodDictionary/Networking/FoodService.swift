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
            
            let task = moyaProvider.request(.food) { [weak self] (result) in
                switch result {
                case let .success(response):
                    guard let data = try? response.map(FoodModel.self) else { return }
                    let transformedData = self?.transformedData(data.COOKRCP01.row)
                    observer(.success(transformedData ?? []))
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

extension FoodService {
    func transformedData(_ data: [OriginFood]) -> [Food] {
        data.map { originData in
            var recipeStep:[Recipe] = []
            if let manual = originData.MANUAL01, let manualImg = originData.MANUAL_IMG01, !manual.isEmpty, !manualImg.isEmpty {
                recipeStep.append(Recipe(MANUAL: manualWithoutIndex(manual), MANUAL_IMG: manualImg))
            }
            if let manual = originData.MANUAL02, let manualImg = originData.MANUAL_IMG02,!manual.isEmpty, !manualImg.isEmpty {
                recipeStep.append(Recipe(MANUAL: manualWithoutIndex(manual), MANUAL_IMG: manualImg))
            }
            if let manual = originData.MANUAL03, let manualImg = originData.MANUAL_IMG03, !manual.isEmpty, !manualImg.isEmpty {
                recipeStep.append(Recipe(MANUAL: manualWithoutIndex(manual), MANUAL_IMG: manualImg))
            }
            if let manual = originData.MANUAL04, let manualImg = originData.MANUAL_IMG04, !manual.isEmpty, !manualImg.isEmpty {
                recipeStep.append(Recipe(MANUAL: manualWithoutIndex(manual), MANUAL_IMG: manualImg))
            }
            if let manual = originData.MANUAL05, let manualImg = originData.MANUAL_IMG05, !manual.isEmpty, !manualImg.isEmpty {
                recipeStep.append(Recipe(MANUAL: manualWithoutIndex(manual), MANUAL_IMG: manualImg))
            }
            if let manual = originData.MANUAL06, let manualImg = originData.MANUAL_IMG06, !manual.isEmpty, !manualImg.isEmpty {
                recipeStep.append(Recipe(MANUAL: manualWithoutIndex(manual), MANUAL_IMG: manualImg))
            }
            if let manual = originData.MANUAL07, let manualImg = originData.MANUAL_IMG07, !manual.isEmpty, !manualImg.isEmpty {
                recipeStep.append(Recipe(MANUAL: manualWithoutIndex(manual), MANUAL_IMG: manualImg))
            }
            if let manual = originData.MANUAL08, let manualImg = originData.MANUAL_IMG08, !manual.isEmpty, !manualImg.isEmpty{
                recipeStep.append(Recipe(MANUAL: manualWithoutIndex(manual), MANUAL_IMG: manualImg))
            }
            if let manual = originData.MANUAL09, let manualImg = originData.MANUAL_IMG09, !manual.isEmpty, !manualImg.isEmpty {
                recipeStep.append(Recipe(MANUAL: manual, MANUAL_IMG: manualImg))
            }
            
            let NewData = Food(
                RCP_NM: originData.RCP_NM,
                RCP_PARTS_DTLS: originData.RCP_PARTS_DTLS,
                RCP_PAT2: originData.RCP_PAT2,
                INFO_WGT: originData.INFO_WGT,
                ATT_FILE_NO_MAIN: originData.ATT_FILE_NO_MAIN,
                ATT_FILE_NO_MK: originData.ATT_FILE_NO_MK,
                RCP_NA_TIP: originData.RCP_NA_TIP,
                RCP_STEP: recipeStep)
            return NewData
        }
    }
    
    func manualWithoutIndex(_ string: String) -> String {
        guard string != ""  else { return "" }
        var stringWithoutIndex = string.components(separatedBy: ".")
        var result = stringWithoutIndex[1].replacingOccurrences(of: "\n", with: " ")
        return result
    }
}
