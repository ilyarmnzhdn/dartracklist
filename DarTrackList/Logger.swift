//
//  Logger.swift
//  DarTrackList
//
//  Created by Ильяр Мнаждин on 10/31/17.
//  Copyright © 2017 Ilyar Mnazhdin. All rights reserved.
//

import Foundation

internal class Logger {
    internal static var debug = false
    
    internal class func log(_ message: String) {
        if debug {
            NSLog(message)
        }
    }
}
