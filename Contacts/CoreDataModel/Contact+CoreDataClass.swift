//
//  Contact+CoreDataClass.swift
//  Contacts
//
//  Created by Harikrishnan S R on 24/09/21.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case username
        case email
        case phone
        case website
        case address
        case company
        
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.website = try container.decode(String.self, forKey: .website)
        self.address = try container.decode(Address.self, forKey: .address)
        self.company = try container.decode(Company.self, forKey: .company)
    }
    
    
}

extension CodingUserInfoKey {
    
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
    
    
}
enum DecoderConfigurationError: Error {
    
  case missingManagedObjectContext
    
}
