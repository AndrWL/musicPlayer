//
//  SearchViewTabController.swift
//  MusicPlayer
//
//  Created by Andrey on 20.04.2021.
//


import UIKit
import Alamofire


class SearchMusicViewController: UITableViewController {
    
    var networkManager = NetworkManager()
    var timer: Timer?
    
    let searchController  = UISearchController(searchResultsController: nil)
    var tracks: [Track] = []
    
    let cellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        tableView.register( UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupSearchBar()
       
    }
    
    func setupSearchBar()  {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.tintColor = .white
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "\(track.trackName) \n \(track.artistName)"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = #imageLiteral(resourceName: "Kanye_West_-_Stronger")
        
        return cell
        
    }
}


extension SearchMusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { (_) in
            self.networkManager.fetchTracks(searchText: searchText) { [weak self] (searchResults) in
                self?.tracks = searchResults?.results ?? []
                self?.tableView.reloadData()
            }
           
        })
          
        
     

       
    }
}
