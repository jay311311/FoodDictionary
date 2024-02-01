//
//  RecipeEntity+CoreDataProperties.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/02/01.
//
//

import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "Recipe")
    }

    @NSManaged public var manual: String?
    @NSManaged public var manualImg: String?

}

extension RecipeEntity : Identifiable {

}
