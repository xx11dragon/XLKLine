//
//  XLKLine.CandleStickMAModel.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/9.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    /// 蜡烛图MA指标
    public struct CandleStickMA: XLKLineLineBrushProtocol {
        
        public var positions: XLKLine.Positions
        
        public var lineColor: UIColor
        
        public var lineWidth: CGFloat
    }
}

// MARK: - 生成数据
public extension XLKLine.CandleStickMA {
    
    /// 计算蜡烛线MA指标
    /// - Parameter model: 当前数据
    /// - Parameter index: 当前数据索引
    /// - Parameter models: 当前数据数组
    /// - Parameter days: 指标参数
    static func generate(models: [XLKLine.Model],
                         index: Int,
                         days: [Int]) {
        
        let model = models[index]
        var ma: [String: Double] = [:]
        for day in days {
            if let value = generateMA(day: day,
                                      model: model,
                                      index: index,
                                      models: models) {
                
                let key = "\(XLKLine.Model.IndicatorType.MA.rawValue)\(day)"
                ma[key] = value
            }
        }
        model.indicator.MA = ma
    }
    
    /// 计算单条蜡烛线MA指标
    /// - Parameter day: 指标参数
    /// - Parameter model: 当前数据
    /// - Parameter index: 当前数据索引
    /// - Parameter models: 当前数据数组
    private static func generateMA(day: Int,
                                   model: XLKLine.Model,
                                   index: Int,
                                   models: [XLKLine.Model]) -> Double? {
        
        if day <= 0 || index < day - 1 {
            
            return nil
        }
        
        guard let modelSum = model.indicator.sumClose else {
            
            return nil
        }
        
        let beforeSum: Double = index > day - 1 ? models[index - day].indicator.sumClose ?? 0 : 0
        return (modelSum - beforeSum) / Double(day)
    }
}

// MARK: - 生成绘制数据
public extension XLKLine.CandleStickMA {
    
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
                         config: XLKLine.Config) -> [XLKLine.CandleStickMA] {
        
        guard models.count > 0 else {
            
            return []
        }
        let paddingTop: CGFloat = config.candleStickContentInset.top
        let indicatorLineWidth = config.candleStickIndicatorLineWidth
        let klineSpace = config.klineSpace
        let klineWidth = config.klineWidth
        let drawMaxY = bounds.height - paddingTop
        let unitValue = (limitValue.max - limitValue.min) / Double(drawMaxY)
        
        var lines: [String: XLKLine.CandleStickMA] = [:]
        for (index, day) in config.candleStickMADays.enumerated() {
            
            let color = config.indicatorColor(type: .MA,
                                              index: index)
            let count = models.count + leadingPreloadModels.count + trailingPreloadModels.count
            let positions = Array<CGPoint?>(repeating: nil,
                                            count: count)
            let key = "\(XLKLine.Model.IndicatorType.MA.rawValue)\(day)"
            
            let item = XLKLine.CandleStickMA(positions: positions,
                                             lineColor: color,
                                             lineWidth: indicatorLineWidth)
            lines[key] = item
        }
        
        for (index, model) in leadingPreloadModels.enumerated() {
            
            for (day, value) in model.indicator.MA ?? [:] {
                
                let displayIndex = leadingPreloadModels.count - index - 1
                let x = -CGFloat(displayIndex) * (klineWidth + klineSpace) - klineWidth * 0.5 - klineSpace
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                lines[day]?.positions[index] = point
            }
        }
        
        for (displayIndex, model) in (models + trailingPreloadModels).enumerated() {
            let modelIndex = leadingPreloadModels.count + displayIndex
            for (day, value) in model.indicator.MA ?? [:] {
                
                let x = CGFloat(displayIndex) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace                
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                lines[day]?.positions[modelIndex] = point
            }
        }
        return Array(lines.values)
    }
}
