//
//  TransactionData+CoreDataProperties.swift
//  SpendTracker
//
//  Created by Tai Chin Huang on 2021/10/19.
//
//

import Foundation
import CoreData


extension TransactionData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionData> {
        return NSFetchRequest<TransactionData>(entityName: "TransactionData")
    }

    @NSManaged public var dateStr: String?
    @NSManaged public var isExpense: Bool
    @NSManaged public var cost: Int32
    @NSManaged public var account: String?
    @NSManaged public var category: String?
    @NSManaged public var memo: String?
    @NSManaged public var image: Data?
    @NSManaged public var contentDescription: String?

}

extension TransactionData : Identifiable {

}
