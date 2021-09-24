//
//  Address+CoreDataProperties.swift
//  Contacts
//
//  Created by Harikrishnan S R on 24/09/21.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var street: String
    @NSManaged public var suite: String
    @NSManaged public var city: String
    @NSManaged public var zipcode: String
    @NSManaged public var geo: Geo?
    @NSManaged public var contact: Contact?

}

extension Address : Identifiable {

}
