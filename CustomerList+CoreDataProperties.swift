//
//  CustomerList+CoreDataProperties.swift
//  WhatIsThis3
//
//  Created by eun-ji on 2023/04/10.
//
//

import Foundation
import CoreData


extension CustomerList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomerList> {
        return NSFetchRequest<CustomerList>(entityName: "CustomerList")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var image: Data?

}

extension CustomerList : Identifiable {

}
