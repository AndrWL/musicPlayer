//
//  TrackDetailView.swift
//  MusicPlayer
//
//  Created by Andrey on 25.04.2021.
//

import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelegate: class {
    func moveBackForPreviusTrack() -> SearchViewModel.Cell?
    func moveForwardPreviusTrack() -> SearchViewModel.Cell?
    
}

class TrackDetailView: UIView {
    
    weak var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    @IBOutlet weak var trackImageView: UIImageView!
    let scale: CGFloat = 0.8
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    let player: AVPlayer  = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    // MARK: Mini View Outlets
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniGoForward: UIButton!
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var miniTrackViewImage: UIImageView!
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    
    @IBOutlet weak var miniPlayPausebutton: UIButton!
    
    // MARK: AWAKE From Nib
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
       
        let scale: CGFloat = 0.8
        trackImageView.layer.cornerRadius = 10
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
       
        
       
        
        setupGestures()
        
        
        
    }
  
    // MARK: Setup
    
    func set(viewModel: SearchViewModel.Cell) {
 
        miniTrackTitleLabel.text = viewModel.trackName
        trackTitleLabel.text = viewModel.trackName
        authorLabel.text = viewModel.artistName
        monitorStartTime()
        observPlayerTimeCurrentTime()
        playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        miniPlayPausebutton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "")  else {
            return  }
        trackImageView.sd_setImage(with: url, completed: nil)
        miniTrackViewImage.sd_setImage(with: url, completed: nil)
        playTrack(previewUrl: viewModel.previewUrl )
        
    }
    
    
    // MARK: Maximazed and Minimazed Gestures
    
    
    private func setupGestures() {
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximazed)))
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismisslPan)))
        
    }
    
    @objc  private func handleTapMaximazed() {
       
        self.tabBarDelegate?.maximizedTrackDetailController(viewModel: nil)
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
      
        
        case .began:
          print("began")
        case .changed:
            
            handlePanPanChanged(gesture: gesture)
        case .ended:
            
            handlePanEnded(gesture: gesture)
      
        @unknown default:
            print("unknown")
           
        }
    }
    
    private func handlePanPanChanged(gesture: UIPanGestureRecognizer) {
        let translation  = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlpha = 1 + translation.y / 200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximizedStackView.alpha = -translation.y / 200
    }
    private func  handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                self.tabBarDelegate?.maximizedTrackDetailController(viewModel: nil)
            } else {
                self.miniTrackViewImage.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        }, completion: nil)
    }
    
    @objc private func handleDismisslPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
       
      
        case .changed:
            let translation = gesture.translation(in: self.superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.maximizedStackView.transform = .identity
                if translation.y > 50 {
                    self.tabBarDelegate?.minimizeTrackDetailController()
                    
                }
                
            }, completion: nil)
        
        @unknown default:
            print("unknown default")
        }
    }
    
    private func playTrack(previewUrl: String?) {
                print("Пытаюсь Включить трек по ссылке ")
        guard let url = URL(string: previewUrl ?? "") else {
            return
        }
        let playerItem = AVPlayerItem(url: url)
        
        player.replaceCurrentItem(with: playerItem)
        player.play()
     
    }
    
    //MARK: Time Setup
    
    
    private func observPlayerTimeCurrentTime() {
        
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            let currentDurationTimeText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.durationLabel.text = "\(currentDurationTimeText)"
            self?.updateCurrentSliderTime()
        }
    }
    
    private func updateCurrentSliderTime() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage =  currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enLargeTrackImage()
        }
    }
    
    // MARK: Animations
    private func enLargeTrackImage() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.trackImageView.transform = .identity
        }, completion: nil)
    }
    private func reduceTrackImage() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.trackImageView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
        }, completion: nil)
    }
    
    // MARK: - @IBActionS
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        
       
        tabBarDelegate?.minimizeTrackDetailController()
      //  self.removeFromSuperview()
    }
    @IBAction func handlerCurrentSlider(_ sender: Any) {
        
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else {
            return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInTimes = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInTimes, preferredTimescale: 1)
        player.seek(to: seekTime)
        
    }
    @IBAction func handlerVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    @IBAction func previuosTrack(_ sender: Any) {
        let cellViewModel = delegate?.moveBackForPreviusTrack()
        guard let cellTrack = cellViewModel else { return  }
        self.set(viewModel: cellTrack)
    }
    @IBAction func nextTrack(_ sender: Any) {
        let cellViewModel = delegate?.moveForwardPreviusTrack()
        guard let cellTrack = cellViewModel else { return  }
        self.set(viewModel: cellTrack)
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        
        if player.timeControlStatus == .paused {
            player.play()
            enLargeTrackImage()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPausebutton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            
        } else {
            player.pause()
            reduceTrackImage()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPausebutton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        
    }
    
  
}


