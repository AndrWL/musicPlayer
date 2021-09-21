//
//  NIB.swift
//  MusicPlayer
//
//  Created by Andrey on 26.04.2021.
//

import UIKit


extension UIView {
    
    class func loadFroamNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
