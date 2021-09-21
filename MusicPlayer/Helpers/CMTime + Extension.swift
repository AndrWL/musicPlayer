//
//  CMTime + Extension.swift
//  MusicPlayer
//
//  Created by Andrey on 26.04.2021.
//

import Foundation
import AVKit

extension CMTime {
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        
        let second = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeForString = String(format: "%02D:%02D", minutes, second)
        
        return timeForString 
    }
    
}
