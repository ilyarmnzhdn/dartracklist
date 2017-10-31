//
//  TrackDataProvider.swift
//  DarChallenge
//
//  Created by Ильяр Мнаждин on 10/30/17.
//  Copyright © 2017 Ilyar Mnazhdin. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftyJSON

typealias TrackFetchCompletion = () -> Void

internal class TrackDataController {
    
    fileprivate var trackProvider: TrackProvider
    fileprivate var trackList: [Track]
    
    internal init() {
        self.trackProvider = TrackProvider()
        self.trackList = [Track]()
    }
    
    internal var trackCount: Int {
        get {
            return self.trackList.count
        }
    }
    
    internal func track(at index: Int) -> Track? {
        
        guard index >= 0 && index < self.trackCount else {
            return nil
        }
        
        return self.trackList[index]
    }
}

extension TrackDataController {
    
    internal func fetchTrackList(completion: @escaping TrackFetchCompletion) {
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let moc = appDelegate.persistentContainer.viewContext
            
            let trackFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Track")
            let sort = NSSortDescriptor(key: #keyPath(Track.title), ascending: true)
            trackFetchRequest.sortDescriptors = [sort]
            
            let fetchedTrackList = try moc.fetch(trackFetchRequest) as! [Track]
            
            guard fetchedTrackList.isEmpty else {
                
                self.trackList = fetchedTrackList
                completion()
                return
            }
            
            self.trackProvider.downloadTrackList { response in
                
                guard let result = response.result.value else {
                    fatalError("Failed to fetch tracks")
                }
                
                self.trackList.removeAll()
                
                
                let managedContext = AppDelegate.shared.persistentContainer.viewContext
                
                let trackEntity = NSEntityDescription.entity(forEntityName: "Track",
                                                             in: managedContext)!
                
                JSON(result).dictionary!["tracks"]!.arrayValue.forEach({ (jsonTrack) in
                    
                    self.trackList.append(Track(entity: trackEntity,
                                                insertInto: managedContext, dictionary: jsonTrack.dictionaryObject!))
                })
                
                self.trackList.sort { $0.title ?? "" < $1.title ?? "" }
                
                AppDelegate.shared.saveContext()
                
                completion()
            }
        } catch {
            fatalError("Failed to fetch tracks: \(error)")
        }
    }
    
    internal func fetchTrack(at index: Int, downloadProgress: @escaping TrackDownloadProgress, completion: @escaping TrackDownloadCompletion) {
        
        guard index >= 0 && index < self.trackCount, let title = self.trackList[index].title else {
            completion(nil)
            return
        }
        
        self.trackProvider.download(track: self.trackList[index], to: { _, _ in
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(title).mp3")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }, downloadProgress: downloadProgress) { (filePath) in
            
            self.trackList[index].filePath = filePath
            
            AppDelegate.shared.saveContext()
            
            completion(filePath)
        }
    }
    
    
    internal func cancelDownloadOfTrack(at index: Int) -> Bool {
        
        guard index >= 0 && index < self.trackCount else {
            return false
        }
        
        self.trackProvider.cancelDownload(of: self.trackList[index])
        
        return true
    }
    
    internal func deleteTrack(at index: Int) -> Bool {
        
        guard index >= 0 && index < self.trackCount else {
            return false
        }
        
        guard let filePath = self.trackList[index].filePath else {
            return false
        }
        
        do {
            try FileManager.default.removeItem(atPath: filePath)
            
            self.trackList[index].filePath = nil
            
            AppDelegate.shared.saveContext()
            
            return true
        } catch {
            Logger.log("Could not remove file: \(error)")
        }
        
        return false
    }
    
    internal func cancelAllDownloads() {
        self.trackProvider.cancelAllDownloads()
    }
}

