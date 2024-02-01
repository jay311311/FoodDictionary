//
//  CoreDataStorage.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/02/01.
//

import Foundation
import RxSwift
import CoreData

class CoreDataStorage {
    
    static let shared = CoreDataStorage()
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
    
    @discardableResult
    func insert(food: Food) {
        let foodEntity = NSEntityDescription.entity(forEntityName: "Food", in: self.mainContext)
        let recipeEntity = NSEntityDescription.entity(forEntityName: "Recipe", in: self.mainContext)
        
        if let foodEntity = foodEntity, let recipeEntity = recipeEntity {
            let foodManagedObject = NSManagedObject(entity: foodEntity, insertInto: self.mainContext)
            let recipeManagedObject = NSManagedObject(entity: recipeEntity, insertInto: self.mainContext)
            
            foodManagedObject.setValue(food.RCP_NM, forKey: "name")
            foodManagedObject.setValue(food.RCP_SEQ, forKey: "serialNum")
            foodManagedObject.setValue(food.RCP_PAT2, forKey: "foodCatgory")
            foodManagedObject.setValue(food.RCP_PARTS_DTLS, forKey: "partDetail")
            foodManagedObject.setValue(food.ATT_FILE_NO_MK, forKey: "imgL")
            foodManagedObject.setValue(food.ATT_FILE_NO_MAIN, forKey: "imgS")
            foodManagedObject.setValue(food.RCP_NA_TIP, forKey: "tip")
            foodManagedObject.setValue(food.RCP_SAVE, forKey: "isSave")
            foodManagedObject.setValue(food.INFO_WGT, forKey: "weight")
            
            for item in food.RCP_STEP {
                recipeManagedObject.setValue(item.MANUAL, forKey: "manual")
                recipeManagedObject.setValue(item.MANUAL_IMG, forKey: "manualImg")
            }
            
            foodManagedObject.setValue(recipeManagedObject, forKey: "recipe")
            
            do {
                try self.mainContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

