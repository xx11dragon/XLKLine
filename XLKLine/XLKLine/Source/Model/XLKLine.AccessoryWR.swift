//
//  XLKLine.AccessoryWR.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/6/10.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    /// 蜡烛图WR指标
    public struct AccessoryWR: XLKLineLineBrushProtocol {
        
        public var positions: XLKLine.Positions
        
        public var lineColor: UIColor
        
        public var lineWidth: CGFloat
    }
}

// MARK: - 生成数据
public extension XLKLine.AccessoryWR {
    
    /// 计算蜡烛线MA指标
    /// - Parameter model: 当前数据
    /// - Parameter index: 当前数据索引
    /// - Parameter models: 当前数据数组
    /// - Parameter days: 指标参数
    static func generate(models: [XLKLine.Model],
                         index: Int,
                         days: [Int]) {
        
        let model = models[index]
        var wr: [String: Double] = [:]
        for day in days {
            if let value = generateWR(day: day,
                                      index: index,
                                      models: models) {
                
                let key = "\(XLKLine.Model.IndicatorType.WR.rawValue)\(day)"
                wr[key] = value
            }
        }
        model.indicator.WR = wr
    }
    
    /// 计算单条蜡烛线WR指标
    /// - Parameter day: 指标参数
    /// - Parameter model: 当前数据
    /// - Parameter index: 当前数据索引
    /// - Parameter models: 当前数据数组
    private static func generateWR(day: Int,
                                   index: Int,
                                   models: [XLKLine.Model]) -> Double? {
        
        if day <= 0 || models.isEmpty || index < day - 1 {
            
            return nil
        }
        let data = Array(models[index - day + 1 ... index])
        var max: Double = data[0].high
        var min: Double = data[0].low
        for item in data {
            max = Swift.max(item.high, max)
            min = Swift.min(item.low, min)
        }
        let model = models[index]
        return max > min ? 100.0 * (max - model.close) / (max - min) : 100
    }
}

// MARK: - 生成绘制数据
public extension XLKLine.AccessoryWR {
    
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
                         config: XLKLine.Config) -> [XLKLine.AccessoryWR] {
        
        guard models.count > 0 else {
            
            return []
        }
        let paddingTop: CGFloat = 0
        let indicatorLineWidth = config.candleStickIndicatorLineWidth
        let klineSpace = config.klineSpace
        let klineWidth = config.klineWidth
        let drawMaxY = bounds.height - paddingTop
        let unitValue = (limitValue.max - limitValue.min) / Double(drawMaxY)
        
        var lines: [String: XLKLine.AccessoryWR] = [:]
        for (index, day) in config.accessoryWR.enumerated() {
            
            let color = config.indicatorColor(type: .WR,
                                              index: index)
            let count = models.count + leadingPreloadModels.count + trailingPreloadModels.count
            let positions = Array<CGPoint?>(repeating: nil,
                                            count: count)
            let key = "\(XLKLine.Model.IndicatorType.WR.rawValue)\(day)"
            let item = XLKLine.AccessoryWR(positions: positions,
                                           lineColor: color,
                                           lineWidth: indicatorLineWidth)
            lines[key] = item
        }
        
        for (index, model) in leadingPreloadModels.enumerated() {
            
            let displayIndex = leadingPreloadModels.count - index - 1
            for (day, value) in model.indicator.WR ?? [:] {
                
                let x = -CGFloat(displayIndex) * (klineWidth + klineSpace) - klineWidth * 0.5 - klineSpace
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                lines[day]?.positions[index] = point
            }
        }
        
        for (displayIndex, model) in (models + trailingPreloadModels).enumerated() {
            let modelIndex = leadingPreloadModels.count + displayIndex
            for (day, value) in model.indicator.WR ?? [:] {
                
                let x = CGFloat(displayIndex) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                lines[day]?.positions[modelIndex] = point
            }
        }
        
        return Array(lines.values)
    }
}
