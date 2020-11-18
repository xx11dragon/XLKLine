//
//  Color.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/4/23.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    public class Color: UIColor {
        
        public convenience init(hex: UInt32,
                                alpha: CGFloat = 1.0) {
            
            let red: CGFloat = CGFloat((hex >> 16) & 0xff) / 255.0
            let green: CGFloat = CGFloat((hex >> 8) & 0xff) / 255.0
            let blue: CGFloat = CGFloat(hex & 0xff) / 255.0
            self.init(red: red,
                      green: green,
                      blue: blue,
                      alpha: alpha)
        }
    }
}
