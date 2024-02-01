//
//  FoodEntity+CoreDataProperties.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/02/01.
//
//

import Foundation
import CoreData


extension FoodEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntity> {
        return NSFetchRequest<FoodEntity>(entityName: "Food")
    }

    @NSManaged public var foodCategory: String?
    @NSManaged public var imgL: String?
    @NSManaged public var imgS: String?
    @NSManaged public var isSave: Bool
    @NSManaged public var name: String?
    @NSManaged public var partDetail: String?
    @NSManaged public var recipe: [RecipeEntity]?
    @NSManaged public var serialNum: String?
    @NSManaged public var tip: String?
    @NSManaged public var weight: String?

}

extension FoodEntity : Identifiable {

}
