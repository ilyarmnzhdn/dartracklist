//
//  TrackCoordinator.swift
//  DarTrackList
//
//  Created by Ильяр Мнаждин on 10/31/17.
//  Copyright © 2017 Ilyar Mnazhdin. All rights reserved.
//

import Foundation
import Alamofire

typealias TrackDownloadCompletion = (String?) -> Void

typealias TrackDownloadProgress = (Double) -> Void

internal class TrackProvider {

    fileprivate static let kSourceURL = "https://vibze.github.io/downloadr-task/tracks.json"
    
    fileprivate var pendingRequestDictionary = [String: DownloadRequest]()
    
    internal func downloadTrackList(completion: @escaping (DataResponse<Any>) -> Void) {
        
        Alamofire.request(TrackProvider.kSourceURL).responseJSON(completionHandler: completion)
    }
    
    internal func download(track: Track, to destination: @escaping DownloadRequest.DownloadFileDestination, downloadProgress: @escaping TrackDownloadProgress, completion: @escaping TrackDownloadCompletion) {
        
        guard let url = track.url, let title = track.title else {
            completion(nil)
            return
        }
        
        let request = Alamofire.download(url, to: destination).downloadProgress(closure: { (progress) in
            
            downloadProgress(progress.fractionCompleted)
        }).responseData { (response) in
            
            completion(response.destinationURL?.path)
            
            self.pendingRequestDictionary.removeValue(forKey: title)
        }
        
        self.pendingRequestDictionary[title] = request
    }
    
    internal func cancelDownload(of track: Track) {
        guard let title = track.title, let request = self.pendingRequestDictionary[title] else {
            return
        }
        
        request.cancel()
        
        self.pendingRequestDictionary.removeValue(forKey: title)
    }
    
    internal func cancelAllDownloads() {
        self.pendingRequestDictionary.forEach { (request) in
            request.value.cancel()
        }
    }
}
