//
//  MainTabBarController.swift
//  MusicPlayer
//
//  Created by Andrey on 20.04.2021.
//

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: class {
        func minimizeTrackDetailController()
        func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?)
    
    
}


class MainTabBarController: UITabBarController {
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    let searchVC: SearchViewController = SearchViewController.loadFroamStroryBoard()
    let trackDetailView: TrackDetailView = TrackDetailView.loadFroamNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let library = Library()
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = #imageLiteral(resourceName: "library")
        hostVC.tabBarItem.title = "Library"
        hostVC.view.backgroundColor = .black
        
        
        tabBar.tintColor = #colorLiteral(red: 0.5568627451, green: 0.9803921569, blue: 0, alpha: 1)
        setupTrackDetailView()
        
        searchVC.tabBarDelegate = self
        
   
        viewControllers = [hostVC,
            generateViewController(rootViewControllet: searchVC, image: #imageLiteral(resourceName: "search"), title: "Search")
            
            
        ]
    }
    
    
    private func generateViewController(rootViewControllet: UIViewController, image: UIImage, title: String) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewControllet)
        
        
      
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewControllet.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
 

    private func setupTrackDetailView()  {
        print("Tут мы будем настраивать  TrackDetailView ")
      
       //  view.addSubview(trackDetailView)
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        trackDetailView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        
        
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.isActive = true
        
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
       
        
        
        
        
        
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    
    
    func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?) {
        
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 0
                        self.trackDetailView.miniTrackView.alpha = 0
                        self.trackDetailView.maximizedStackView.alpha = 1
                       },
                       completion: nil)
        guard let viewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: viewModel)
       
    }
    
    
    func minimizeTrackDetailController() {
        
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 1
                        self.trackDetailView.miniTrackView.alpha = 1
                        self.trackDetailView.maximizedStackView.alpha = 0
                       },
                       completion: nil)
    }
    
    
}
