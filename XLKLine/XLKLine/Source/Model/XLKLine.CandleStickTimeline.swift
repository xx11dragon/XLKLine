//
//  XLKLine.CandleStickTimeline.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/6/22.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    /// 蜡烛图MA指标
    public struct CandleStickTimeline: XLKLineLineBrushProtocol {
        
        public var positions: XLKLine.Positions
        
        public var lineColor: UIColor
        
        public var lineWidth: CGFloat
        
        /// 填充渐变顶部颜色
        public var fillGradualTopColor: UIColor
        
        /// 填充渐变底部颜色
        public var fillGradualBottomColor: UIColor
    }
}

// MARK: - 生成数据
public extension XLKLine.CandleStickTimeline {
    
    /// 生成绘制数据
    /// - Parameter models: 数据
    /// - Parameter bounds: 显示区域尺寸
    /// - Parameter limitValue: 边界值
    /// - Parameter config: 配置对象
    static func generate(models: [XLKLine.Model],
                         leadingPreloadModels: [XLKLine.Model],
                         trailingPreloadModels: [XLKLine.Model],
                         bounds: CGRect,
                         limitValue: XLKLine.LimitValue,
                         config: XLKLine.Config) -> XLKLine.CandleStickTimeline? {
        
        let contentInset = config.candleStickContentInset
        let klineWidth = config.klineWidth
        let klineSpace = config.klineSpace
        let lineWidth = config.candleStickTimelineWidth
        let lineColor = config.candleStickTimelineColor
        let maxHeight = bounds.height - contentInset.top - contentInset.bottom
        let unitValue = (limitValue.max - limitValue.min) / Double(maxHeight)
        var postitons: [CGPoint] = []
        
        for (index, model) in leadingPreloadModels.enumerated() {
            
            let displayIndex = leadingPreloadModels.count - index - 1
            let x = -CGFloat(displayIndex) * (klineWidth + klineSpace) - klineWidth * 0.5 - klineSpace
            let close = abs(maxHeight - CGFloat((model.close - limitValue.min) / unitValue)) + contentInset.top
            postitons.append(CGPoint(x: x, y: close))
        }

        for (index, model) in (models + trailingPreloadModels).enumerated() {
            
            let x = CGFloat(index) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace
            let close = maxHeight - CGFloat((model.close - limitValue.min) / unitValue) + contentInset.top
            postitons.append(CGPoint(x: x, y: close))
        }
        return XLKLine.CandleStickTimeline(positions: postitons,
                                           lineColor: lineColor,
                                           lineWidth: lineWidth,
                                           fillGradualTopColor: config.candleStickTimelineFillGradualTopColor,
                                           fillGradualBottomColor: config.candleStickTimelineFillGradualBottomColor)
    }
}
