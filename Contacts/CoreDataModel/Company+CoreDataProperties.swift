//
//  Company+CoreDataProperties.swift
//  Contacts
//
//  Created by Harikrishnan S R on 24/09/21.
//
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var name: String
    @NSManaged public var catchPhrase: String
    @NSManaged public var bs: String
    @NSManaged public var contact: Contact

}

extension Company : Identifiable {

}
