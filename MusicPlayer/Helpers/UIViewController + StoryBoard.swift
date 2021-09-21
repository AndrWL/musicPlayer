//
//  UIViewController + StoryBoard.swift
//  MusicPlayer
//
//  Created by Andrey on 21.04.2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func loadFroamStroryBoard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyBoard = UIStoryboard(name: name, bundle: nil) 
        if let viewController = storyBoard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("Error no initial view controller in \(name) storyBoard")
        }
    }
}
