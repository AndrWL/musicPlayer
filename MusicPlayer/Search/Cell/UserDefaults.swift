//
//  UserDefaults.swift
//  MusicPlayer
//
//  Created by Andrey on 18.05.2021.
//

import Foundation


extension UserDefaults {
    
    static let favoriteTrackKey = "favouriteTrackKey"
    
    func savedTracks() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        guard let savedTracks = defaults.object(forKey: UserDefaults.favoriteTrackKey) as? Data else { return  [] }
        guard let decodeTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] else { return [] }
        return decodeTracks
            
    }
        
}
