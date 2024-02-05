//
//  FoodEntity+CoreDataProperties.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2/5/24.
//
//

import Foundation
import CoreData


extension FoodEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntity> {
        return NSFetchRequest<FoodEntity>(entityName: "Food")
    }

    @NSManaged public var category: String?
    @NSManaged public var imgL: String?
    @NSManaged public var imgS: String?
    @NSManaged public var infoWgt: String?
    @NSManaged public var isSave: Bool
    @NSManaged public var manual1: String?
    @NSManaged public var manual1Img: String?
    @NSManaged public var manual2: String?
    @NSManaged public var manual2Img: String?
    @NSManaged public var manual3: String?
    @NSManaged public var manual3Img: String?
    @NSManaged public var manual4: String?
    @NSManaged public var manual4Img: String?
    @NSManaged public var manual5: String?
    @NSManaged public var manual5Img: String?
    @NSManaged public var manual6: String?
    @NSManaged public var manual6Img: String?
    @NSManaged public var manual7: String?
    @NSManaged public var manual7Img: String?
    @NSManaged public var manual8: String?
    @NSManaged public var manual9: String?
    @NSManaged public var name: String?
    @NSManaged public var partDetail: String?
    @NSManaged public var serialNum: String?
    @NSManaged public var manual8Img: String?
    @NSManaged public var manual9Img: String?

}

extension FoodEntity : Identifiable {

}
