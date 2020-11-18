//
//  XLKLine.VolumeMA.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/28.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    /// 蜡烛图MA指标
    public struct VolumeMA: XLKLineLineBrushProtocol {
        
        public var positions: XLKLine.Positions
        
        public var lineColor: UIColor
        
        public var lineWidth: CGFloat
    }
}

// MARK: - 生成数据
public extension XLKLine.VolumeMA {
    
    /// 计算交易量MA指标
    /// - Parameter model: 当前数据
    /// - Parameter index: 当前数据索引
    /// - Parameter models: 当前数据数组
    static func generate(models: [XLKLine.Model],
                         index: Int,
                         days: [Int]) {
        
        if index < 0 || models.count <= index {
            return
        }
        var ma: [String: Double] = [:]
        for day in days {
            if let value = generateMA(day: day,
                                      models: models,
                                      index: index) {
                let key = "\(XLKLine.Model.IndicatorType.MA_VOLUME.rawValue)\(day)"
                ma[key] = value
            }
        }
        models[index].indicator.MA_VOLUME = ma
    }
    
    /// 生成单条交易量MA指标
    /// - Parameter day: 指标参数
    /// - Parameter model: 当前数据
    /// - Parameter index: 当前数据索引
    /// - Parameter models: 当前数据所在模型
    private static func generateMA(day: Int,
                                   models: [XLKLine.Model],
                                   index: Int) -> Double? {
        
        if day <= 0 || index < (day - 1) {
            
            return nil
        }
        
        let model = models[index]
        
        guard let modelSum = model.indicator.sumVolume else {
            
            return nil
        }
        
        if index == (day - 1) {
            
            return modelSum / Double(day)
        } else {
            
            guard let beforeSum = models[index - day].indicator.sumVolume else {
                
                return nil
            }
            return (modelSum - beforeSum) / Double(day)
        }
    }
}

// MARK: - 生成绘制数据
public extension XLKLine.VolumeMA {
    
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
                         config: XLKLine.Config) -> [XLKLine.VolumeMA] {
        
        guard models.count > 0 else {
            
            return []
        }

        let indicatorLineWidth = config.volumeIndicatorLineWidth
        let klineSpace = config.klineSpace
        let klineWidth = config.klineWidth
        let paddingTop = config.volumeContentInset.top
        let drawMaxY = bounds.height - paddingTop
        let unitValue = (limitValue.max - limitValue.min) / Double(drawMaxY)
        var lines: [String: XLKLine.VolumeMA] = [:]
        let type = XLKLine.Model.IndicatorType.MA_VOLUME
        for (index, day) in config.volumeMADays.enumerated() {
            
            let color = config.indicatorColor(type: type,
                                              index: index)
            let count = models.count + leadingPreloadModels.count + trailingPreloadModels.count
            let positions = Array<CGPoint?>(repeating: nil,
                                            count: count)
            let key = "\(type.rawValue)\(day)"
            let item = XLKLine.VolumeMA(positions: positions,
                                        lineColor: color,
                                        lineWidth: indicatorLineWidth)
            lines[key] = item
        }
        
        for (index, model) in leadingPreloadModels.enumerated() {
            
            let displayIndex = leadingPreloadModels.count - index - 1
            for (day, value) in model.indicator.MA_VOLUME ?? [:] {
                
                let x = -CGFloat(displayIndex) * (klineWidth + klineSpace) - klineWidth * 0.5 - klineSpace
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                lines[day]?.positions[index] = point
            }
        }

        for (displayIndex, model) in (models + trailingPreloadModels).enumerated() {
            let modelIndex = leadingPreloadModels.count + displayIndex
            for (day, value) in model.indicator.MA_VOLUME ?? [:] {
                
                let x = CGFloat(displayIndex) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                lines[day]?.positions[modelIndex] = point
            }
        }
        return Array(lines.values)
    }
}
