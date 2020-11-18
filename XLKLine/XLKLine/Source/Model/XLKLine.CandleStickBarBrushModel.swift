//
//  XLKLineCandleStickBrushModel.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/8.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    public struct CandleStickBarBrushModel: XLKLineCandleStickBarBrushProtocol {
        
        public var body: XLKLineLineBrushProtocol
        
        public var shadow: XLKLineLineBrushProtocol
        
        public var space: CGFloat
    }
}

extension XLKLine.CandleStickBarBrushModel {
    
    public static func generate(models: [XLKLine.Model],
                                bounds: CGRect,
                                contentInset: UIEdgeInsets,
                                limitValue: XLKLine.LimitValue,
                                config: XLKLine.Config) -> [XLKLineCandleStickBarBrushProtocol] {
        
        let klineWidth = config.klineWidth
        let klineSpace = config.klineSpace
        let shadowLineWidth = config.klineShadowLineWidth
        let increaseColor = config.increaseColor
        let decreaseColor = config.decreaseColor
        let maxHeight = bounds.height - contentInset.top - contentInset.bottom
        let unitValue = (limitValue.max - limitValue.min) / Double(maxHeight)
        var result: [XLKLine.CandleStickBarBrushModel] = []
        for (index, model) in models.enumerated() {
            
            let x = CGFloat(index) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace
            let open = abs(maxHeight - CGFloat((model.open - limitValue.min) / unitValue)) + contentInset.top
            let close = abs(maxHeight - CGFloat((model.close - limitValue.min) / unitValue)) + contentInset.top
            let high = abs(maxHeight - CGFloat((model.high - limitValue.min) / unitValue)) + contentInset.top
            let low = abs(maxHeight - CGFloat((model.low - limitValue.min) / unitValue)) + contentInset.top
            let color = model.open <= model.close ? increaseColor : decreaseColor
            let bodyPostions = [CGPoint(x: x, y: open), CGPoint(x: x, y: close)]
            let shadowPostions = [CGPoint(x: x, y: high), CGPoint(x: x, y: low)]
            
            let body = XLKLine.LineBrush.Model(positions: bodyPostions,
                                               lineColor: color,
                                               lineWidth: klineWidth)
            let shadow = XLKLine.LineBrush.Model(positions: shadowPostions,
                                                 lineColor: color,
                                                 lineWidth: shadowLineWidth)
            let item = XLKLine.CandleStickBarBrushModel(body: body,
                                                        shadow: shadow,
                                                        space: klineSpace)
            result.append(item)
        }
        return result
    }
}
