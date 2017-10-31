//
//  TrackTableViewController.swift
//  DarChallenge
//
//  Created by Ильяр Мнаждин on 10/30/17.
//  Copyright © 2017 Ilyar Mnazhdin. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

class TrackTableViewController: UITableViewController {

    fileprivate var trackDataController: TrackDataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.trackDataController = TrackDataController()
        
        self.trackDataController.fetchTrackList() {
            self.tableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.trackDataController.cancelAllDownloads()
    }
}

extension TrackTableViewController {
    
    
    // MARK: - UI Action handlers
    @IBAction func trackActionTouchUpInside(_ sender: UIButton) {
        
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? TrackTableViewCell else {
            return
        }
        
        switch cell.state {
        case .Downloaded:
            
            _ = self.trackDataController.deleteTrack(at: sender.tag)
            
            cell.state = .NotDownloaded
        case .NotDownloaded:
            
            cell.state = .Downloading
            
            self.trackDataController.fetchTrack(at: sender.tag, downloadProgress: { (progress) in
                cell.progressBar.setProgress(Float(progress), animated: true)
            }, completion: { (response) in
                guard response != nil else {
                    cell.state = .NotDownloaded
                    return
                }
                
                cell.state = .Downloaded
            })
            
        case .Downloading:
            
            _ = self.trackDataController.cancelDownloadOfTrack(at: sender.tag)
            
            cell.state = .NotDownloaded
        }
    }
}

// MARK: - Table view data source
extension TrackTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.trackDataController.trackCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackTableViewCell
        
        guard let track = self.trackDataController.track(at: indexPath.row) else {
            
            return UITableViewCell()
        }
        
        cell.setupCell(with: track, at: indexPath.row)

        return cell
    }
}

// MARK: - Table view delegate
extension TrackTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let filePath = self.trackDataController.track(at: indexPath.row)?.filePath else {
            return
        }
        
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(URL(fileURLWithPath: filePath).lastPathComponent)
        
        let playerItem = AVPlayerItem(url: destinationUrl)
        
        let player = AVPlayer(playerItem: playerItem)
        player.actionAtItemEnd = .none
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        
        present(controller, animated: true) {
            player.play()
        }
    }
}
