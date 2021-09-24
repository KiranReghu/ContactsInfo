//
//  Geo+CoreDataClass.swift
//  Contacts
//
//  Created by Harikrishnan S R on 24/09/21.
//
//

import Foundation
import CoreData

@objc(Geo)
public class Geo: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        
       case lat
       case lng
 
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lat = try container.decode(String.self, forKey: .lat)
        self.lng = try container.decode(String.self, forKey: .lng)
        
    }
    
}
