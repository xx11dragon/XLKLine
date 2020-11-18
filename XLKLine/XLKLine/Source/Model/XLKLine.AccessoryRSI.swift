//
//  XLKLine.AccessoryRSI.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/6/9.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    /// 蜡烛图RSI指标
    public struct AccessoryRSI: XLKLineLineBrushProtocol {
        
        public var positions: XLKLine.Positions
        
        public var lineColor: UIColor
        
        public var lineWidth: CGFloat
    }
}

// MARK: - 生成数据
public extension XLKLine.AccessoryRSI {
    
    /// 计算蜡烛线MA指标
    /// - Parameter model: 当前数据
    /// - Parameter index: 当前数据索引
    /// - Parameter models: 当前数据数组
    /// - Parameter days: 指标参数
    static func generate(models: [XLKLine.Model],
                         index: Int,
                         days: [Int]) {
        
        let model = models[index]
        var rsi: [String: Double] = [:]
        for day in days {
            if let value = generateRSI(day: day,
                                       model: model,
                                       index: index,
                                       models: models) {
                
                let key = "\(XLKLine.Model.IndicatorType.RSI.rawValue)\(day)"
                rsi[key] = value
            }
        }
        model.indicator.RSI = rsi
    }
    
    /// 计算单条蜡烛线RSI指标
    /// - Parameter day: 指标参数
    /// - Parameter model: 当前数据
    /// - Parameter index: 当前数据索引
    /// - Parameter models: 当前数据数组
    private static func generateRSI(day: Int,
                                    model: XLKLine.Model,
                                    index: Int,
                                    models: [XLKLine.Model]) -> Double? {
        
        if day <= 0 || models.isEmpty {
            
            return nil
        }
        let previous: XLKLine.Model = index > 0 ? models[index - 1] : models[0]
        let current: XLKLine.Model = models[index]
        let day = Double(day)
        let key = "\(XLKLine.Model.IndicatorType.RSI.rawValue)\(day)"
        let maxClose = max(current.close - previous.close, 0)
        let absClose = abs(current.close - previous.close)
        let previousMaxEMA = previous.indicator.RSIMaxEMA[key]
        let previousAbsEMA = previous.indicator.RSIAbsEMA[key]
        let maxEMA = previousMaxEMA != nil ? sma(previous: previousMaxEMA!, X: maxClose, N: day, M: 1) : 0
        let absEMA = previousAbsEMA != nil ? sma(previous: previousAbsEMA!, X: absClose, N: day, M: 1) : 0
        current.indicator.RSIMaxEMA[key] = maxEMA
        current.indicator.RSIAbsEMA[key] = absEMA
        let rsi = absEMA != 0 ? maxEMA / absEMA * 100 : 0
        return Double(index) >= day ? rsi : nil
    }
    
    static func sma(previous: Double, X: Double, N: Double, M: Double) -> Double {
        
        return (M * X + (N - M) * previous) / N
    }
}

// MARK: - 生成绘制数据
public extension XLKLine.AccessoryRSI {
    
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
                         config: XLKLine.Config) -> [XLKLine.AccessoryRSI] {
        
        guard models.count > 0 else {
            
            return []
        }
        let paddingTop: CGFloat = 0
        let indicatorLineWidth = config.candleStickIndicatorLineWidth
        let klineSpace = config.klineSpace
        let klineWidth = config.klineWidth
        let drawMaxY = bounds.height - paddingTop
        let unitValue = (limitValue.max - limitValue.min) / Double(drawMaxY)
        
        var lines: [String: XLKLine.AccessoryRSI] = [:]
        for (index, day) in config.accessoryRSI.enumerated() {
            
            let color = config.indicatorColor(type: .RSI,
                                              index: index)
            let count = models.count + leadingPreloadModels.count + trailingPreloadModels.count
            let positions = Array<CGPoint?>(repeating: nil,
                                            count: count)
            let key = "\(XLKLine.Model.IndicatorType.RSI.rawValue)\(day)"
            
            let item = XLKLine.AccessoryRSI(positions: positions,
                                            lineColor: color,
                                            lineWidth: indicatorLineWidth)
            lines[key] = item
        }
        
        for (index, model) in leadingPreloadModels.enumerated() {
            
            let displayIndex = leadingPreloadModels.count - index - 1
            for (day, value) in model.indicator.RSI ?? [:] {
                
                let x = -CGFloat(displayIndex) * (klineWidth + klineSpace) - klineWidth * 0.5 - klineSpace
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                lines[day]?.positions[index] = point
            }
        }
        
        
        for (displayIndex, model) in (models + trailingPreloadModels).enumerated() {
            let modelIndex = leadingPreloadModels.count + displayIndex
            for (day, value) in model.indicator.RSI ?? [:] {
                
                let x = CGFloat(displayIndex) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                lines[day]?.positions[modelIndex] = point
            }
        }
        
        return Array(lines.values)
    }
}
