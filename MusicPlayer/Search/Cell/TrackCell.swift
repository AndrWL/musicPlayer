//
//  TrackCell.swift
//  MusicPlayer
//
//  Created by Andrey on 22.04.2021.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var collectionName: String { get }
    var artistName: String { get }
}

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
    
    @IBOutlet weak var TrackName: UILabel!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var collectiionNameLabel: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    @IBOutlet weak var addTrackOutlet: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
    
    
    var cell: SearchViewModel.Cell?
    func setupCell(viewModel: SearchViewModel.Cell) {
        self.cell = viewModel
        let savedtrack = UserDefaults.standard.savedTracks()
        let hasFavourite = savedtrack.firstIndex(where: { $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName }) != nil
        if hasFavourite {
            addTrackOutlet.isHidden = true
        } else {
            addTrackOutlet.isHidden = false

        }
        
     
        
        TrackName.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectiionNameLabel.text = viewModel.collectionName
        guard let url = URL(string: viewModel.iconUrlString ?? "") else {
            return
        }
        trackImageView.sd_setImage(with: url, completed: nil)
        
    }
    @IBAction func addTrackAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        guard let cell = cell else { return  }
        addTrackOutlet.isHidden = true
        
        var listOfTracks = defaults.savedTracks()
     
        
        listOfTracks.append(cell)
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            defaults.set(saveData, forKey: UserDefaults.favoriteTrackKey)
        }
        
    }

    
    
    
}

