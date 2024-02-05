//
//  CoreDataStorage.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/02/01.
//

import Foundation
import RxSwift
import RxRelay
import CoreData

class CoreDataStorage {
    
    static let shared = CoreDataStorage()
    var savedListSubject = BehaviorRelay<[Food]>(value: [])

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FoodDictionary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var mainContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var entity:  NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "Food", in: self.mainContext)
    }
    
    func insertFood(food: Food) {
        let disposeBag = DisposeBag()
        if let entity = entity {
            let foodManagedObject = NSManagedObject(entity: entity, insertInto: self.mainContext)

            savedListSubject.subscribe(onNext: { [weak self] foodList in
                if !foodList.contains(where: {$0.RCP_NM == food.RCP_NM}) {
                    foodManagedObject.setValue(food.RCP_NM, forKey: "name")
                    foodManagedObject.setValue(food.ATT_FILE_NO_MAIN, forKey: "imgS")
                    foodManagedObject.setValue(food.ATT_FILE_NO_MK, forKey: "imgL")
                    foodManagedObject.setValue(food.INFO_WGT, forKey: "infoWgt")
                    foodManagedObject.setValue(food.RCP_SAVE, forKey: "isSave")
                    foodManagedObject.setValue(food.RCP_PARTS_DTLS, forKey: "partDetail")
                    foodManagedObject.setValue(food.RCP_PAT2, forKey: "category")
                    foodManagedObject.setValue(food.RCP_SEQ, forKey: "serialNum")
                    
                    for (index, item)in  food.RCP_STEP.enumerated() {
                        foodManagedObject.setValue(item.MANUAL, forKey: "manual\(index + 1)")
                        foodManagedObject.setValue(item.MANUAL_IMG, forKey: "manual\(index + 1)Img")
                    }

                    self?.saveToContext()
                }
            })
            .disposed(by: disposeBag)
        }
    }
    
    func readFood() {
        var foodList: [Food] = []
        let results = fetch(request: FoodEntity.fetchRequest())
        
        for result in results {
            let food = Food(
                RCP_NM: result.name ?? "",
                RCP_SEQ: "",
                RCP_SAVE: true,
                RCP_PARTS_DTLS: "",
                RCP_PAT2: "",
                INFO_WGT: "",
                ATT_FILE_NO_MAIN: result.imgS,
                ATT_FILE_NO_MK: "",
                RCP_NA_TIP: "",
                RCP_STEP: [Recipe(MANUAL: result.manual1 ?? "", MANUAL_IMG: result.manual1Img ?? ""),
                           Recipe(MANUAL: result.manual2 ?? "", MANUAL_IMG: result.manual2Img ?? ""),
                           Recipe(MANUAL: result.manual3 ?? "", MANUAL_IMG: result.manual3Img ?? ""),
                           Recipe(MANUAL: result.manual4 ?? "", MANUAL_IMG: result.manual4Img ?? ""),
                           Recipe(MANUAL: result.manual5 ?? "", MANUAL_IMG: result.manual5Img ?? ""),
                           Recipe(MANUAL: result.manual6 ?? "", MANUAL_IMG: result.manual6Img ?? ""),
                           Recipe(MANUAL: result.manual7 ?? "", MANUAL_IMG: result.manual7Img ?? ""),
                           Recipe(MANUAL: result.manual8 ?? "", MANUAL_IMG: result.manual8Img ?? ""),
                           Recipe(MANUAL: result.manual9 ?? "", MANUAL_IMG: result.manual9Img ?? "")
                          ]
            )
            foodList.append(food)
        }
        savedListSubject.accept(foodList)
    }
    
    func getFood() -> [Food] {
        readFood()
        return savedListSubject.value
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.mainContext.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteFood(name: String){
        // Delete with CoreData
        let fetchResults = fetch(request: FoodEntity.fetchRequest())
        let food = fetchResults.filter({ $0.name == name })[0]
        mainContext.delete(food)
        saveToContext()
        
        // DeleteWithRxSwift
        var saveList = savedListSubject.value
        saveList = saveList.filter({ $0.RCP_NM != name})
        savedListSubject.accept(saveList)
    }
    
    func deleteFoodAll(){
        let fetchResults = fetch(request: FoodEntity.fetchRequest())
        for result in fetchResults {
            mainContext.delete(result)
        }
        saveToContext()
    }
    
    func saveToContext() {
        do {
            try mainContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

