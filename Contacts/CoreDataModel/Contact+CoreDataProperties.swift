//
//  Contact+CoreDataProperties.swift
//  Contacts
//
//  Created by Harikrishnan S R on 24/09/21.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String
    @NSManaged public var username: String
    @NSManaged public var email: String
    @NSManaged public var phone: String
    @NSManaged public var website: String
    @NSManaged public var address: Address?
    @NSManaged public var company: Company?

}

extension Contact : Identifiable {

}
