//
//  XLKline.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/7/2.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine.DetailView {
    
    /// 显示信息类型
    enum InfoType {
        
        case time   //  时间
        case open   //  开
        case high   //  高
        case low    //  低
        case close  //  收
        case change //  涨跌额
        case chg    //  涨跌幅
        case volume //  交易量
    }
    
    class InfoLayer: CALayer {
        
        /// 显示的数据类型
        let infoTypes: [InfoType]
        
        /// 文案字体
        let textFont: UIFont
        
        /// 文案颜色
        let textColor: UIColor
        
        /// 显示的文案Layer
        var textLayers: [CATextLayer] = []
        
        /// 初始化显示文案Layers
        func initTextLayers() {

            for _ in infoTypes {

                let textLayer = XLKLine.TextLayer(font: textFont,
                                                  textColor: textColor)
                addSublayer(textLayer)
                textLayers.append(textLayer)
            }
        }
        
        func layoutTextLayers() {
            
            let x: CGFloat = 5
            let width: CGFloat = bounds.width - x
            let height: CGFloat = bounds.height / CGFloat(infoTypes.count)
            for (index, type) in infoTypes.enumerated() {
                let y = CGFloat(index) * height
                let textLayer = textLayers[index]
//                textLayer.string =
            }
        }
        
        
        
        // MARK: - Init
        init(infoTypes: [InfoType],
             textFont: UIFont,
             textColor: UIColor,
             model: XLKLine.Model) {
            
            self.infoTypes = infoTypes
            self.textFont = textFont
            self.textColor = textColor
            super.init()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
