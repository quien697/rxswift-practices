//
//  Memo+CoreDataProperties.swift
//  
//
//  Created by Quien on 2023/3/7.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?
    @NSManaged public var identity: String?
    @NSManaged public var insertDate: Date?

}
