//
//  XLKLine.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/7/2.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    class TextLayer: CATextLayer {
        
        init(font: UIFont,
             textColor: UIColor) {
            super.init()
            
            self.font = CGFont(font.fontName as CFString)
            self.fontSize = font.pointSize
            self.foregroundColor = textColor.cgColor
            self.isWrapped = true
            self.contentsScale = UIScreen.main.scale
            self.alignmentMode = .left
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
