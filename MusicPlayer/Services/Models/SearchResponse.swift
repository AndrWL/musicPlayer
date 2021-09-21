//
//  SearchResponse.swift
//  MusicPlayer
//
//  Created by Andrey on 21.04.2021.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
    
}

struct Track: Decodable {
    var trackName: String
    var artistName: String
    var collectionName: String?
    var artworkUrl100: String
    var previewUrl: String?
}
