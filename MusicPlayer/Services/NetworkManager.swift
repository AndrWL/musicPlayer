//
//  NetworkManager.swift
//  MusicPlayer
//
//  Created by Andrey on 21.04.2021.
//


import Alamofire
import UIKit
class NetworkManager {
    
    
    func fetchTracks(searchText: String, competion: @escaping (SearchResponse?) -> Void) {
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term":"\(searchText)", "limit":"100", "media":"music" ]
          
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print(error.localizedDescription)
                competion(nil)
                return
            }
            
            
            guard let data = dataResponse.data else { return }
            
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(SearchResponse.self, from: data)
             
                competion(object)
                
            } catch let error {
                print("No data \(error.localizedDescription)")
                 competion(nil)
                
            }
        }
     
        
       
    }
}
