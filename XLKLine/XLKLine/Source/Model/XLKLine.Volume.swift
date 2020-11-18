//
//  XLKLine.VolumeBrushModel.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/28.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    public struct Volume {
        
        /// 生成显示数据
        /// - Parameter models: 数据
        /// - Parameter bounds: 显示区域尺寸
        /// - Parameter limitValue: 边界值
        /// - Parameter config: 配置对象
        static func generate(models: [XLKLine.Model],
                             bounds: CGRect,
                             limitValue: XLKLine.LimitValue,
                             config: XLKLine.Config) -> [XLKLineLineBrushProtocol] {
            
            let lineWidth = config.klineWidth
            let lineSpace = config.klineSpace
            let increaseColor = config.increaseColor
            let decreaseColor = config.decreaseColor
            let paddingTop = config.volumeContentInset.top
            let baseHeight = bounds.height / 5
            let drawMaxY = bounds.height - paddingTop - baseHeight
            let unitValue = (limitValue.max - limitValue.min) / Double(drawMaxY)
            var result: [XLKLineLineBrushProtocol] = []
            for (index, model) in models.enumerated() {
                
                let x = CGFloat(index) * (lineWidth + lineSpace) + lineWidth * 0.5 + lineSpace
                let top = abs(drawMaxY - CGFloat((model.volume - limitValue.min) / unitValue)) + paddingTop
                let bottom = drawMaxY + paddingTop + baseHeight
                let lineColor = model.open <= model.close ? increaseColor : decreaseColor
                let startPoint = CGPoint(x: x,
                                         y: top)
                let endPoint = CGPoint(x: x,
                                       y: bottom)
                let brushModel = XLKLine.LineBrush.Model(positions: [startPoint, endPoint],
                                                         lineColor: lineColor,
                                                         lineWidth: lineWidth)
                result.append(brushModel)
            }
            return result
        }
    }
}
