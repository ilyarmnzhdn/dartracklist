//
//  TrackTableViewCell.swift
//  DarChallenge
//
//  Created by Ильяр Мнаждин on 10/30/17.
//  Copyright © 2017 Ilyar Mnazhdin. All rights reserved.
//

import UIKit

internal enum TrackCellState {
    case Downloaded
    case Downloading
    case NotDownloaded
}

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var labelInfo: UILabel!

    private var _filePath: String!
    private var _state: TrackCellState!
    
    internal var state: TrackCellState {
        get {
            return self._state
        }
        set(newValue) {
            self._state = newValue
            
            switch newValue {
            case .Downloaded:
                
                self.progressBar.isHidden = true
                self.progressBar.setProgress(0, animated: false)
                
                self.buttonAction.setTitle("Delete", for: .normal)
                self.buttonAction.setTitleColor(UIColor.red, for: .normal)
                
                self.selectionStyle = UITableViewCellSelectionStyle.default
            case .Downloading:
                
                self.progressBar.setProgress(0, animated: false)
                self.progressBar.isHidden = false
                
                self.buttonAction.setTitle("Cancel", for: .normal)
                self.buttonAction.setTitleColor(UIColor.darkGray, for: .normal)
                
                self.selectionStyle = UITableViewCellSelectionStyle.none
            case .NotDownloaded:
                
                self.progressBar.isHidden = true
                self.progressBar.setProgress(0, animated: false)
                
                self.buttonAction.setTitle("Download", for: .normal)
                self.buttonAction.setTitleColor(UIColor.customCyan, for: .normal)
                
                self.selectionStyle = UITableViewCellSelectionStyle.none
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.state = .NotDownloaded
        
        self.labelTitle.text = ""
        self.labelInfo.text = ""
    }
    
    internal func setupCell(with track: Track, at index: Int) {
        
        if let title = track.title {
            self.labelTitle.text = title
        }
        
        if let artist = track.artist {
            self.labelInfo.text = artist
        }
        
        self.buttonAction.tag = index
        
        if track.filePath != nil {
            self.state = .Downloaded
            self._filePath = track.filePath
        }
        else {
            self.state = .NotDownloaded
        }
    }
}
