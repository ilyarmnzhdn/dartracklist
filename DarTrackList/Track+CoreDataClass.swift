//
//  Track+CoreDataClass.swift
//  DarTrackList
//
//  Created by Ильяр Мнаждин on 10/31/17.
//  Copyright © 2017 Ilyar Mnazhdin. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

public class Track: NSManagedObject {
    
    convenience init(entity: NSEntityDescription, insertInto: NSManagedObjectContext?, dictionary: [String: Any]) {
        self.init(entity: entity, insertInto: insertInto)
        
        self.title = dictionary["title"] as? String
        self.artist = dictionary["artist"] as? String
        self.album = dictionary["album"] as? String
        
        guard var insecureURL = dictionary["url"] as? String else {
            return
        }
        
        let targetIndex = insecureURL.index(insecureURL.startIndex, offsetBy: 4)
        let endIndex = insecureURL.index(targetIndex, offsetBy: 1)
        
        if insecureURL[targetIndex..<endIndex] != "s" {
            insecureURL.insert("s", at: insecureURL.index(insecureURL.startIndex, offsetBy: 4))
        }
        
        self.url = insecureURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
}
