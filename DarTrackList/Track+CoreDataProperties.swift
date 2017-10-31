//
//  Track+CoreDataProperties.swift
//  DarTrackList
//
//  Created by Ильяр Мнаждин on 10/31/17.
//  Copyright © 2017 Ilyar Mnazhdin. All rights reserved.
//

import Foundation
import CoreData


extension Track {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }
    
    @nonobjc public func trackInfo() -> String {
        return "By \(artist ?? "") from \(album ?? "") album."
    }

    @NSManaged public var title: String?
    @NSManaged public var artist: String?
    @NSManaged public var album: String?
    @NSManaged public var filePath: String?
    @NSManaged public var url: String?
}
