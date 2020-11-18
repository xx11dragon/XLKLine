//
//  XLKLine.CandleStickBOLL.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/27.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    /// 蜡烛图MA指标
    public struct CandleStickBOLL: XLKLineLineBrushProtocol {
        
        public var positions: XLKLine.Positions
        
        public var lineColor: UIColor
        
        public var lineWidth: CGFloat
    }
}

// MARK: - 生成数据
public extension XLKLine.CandleStickBOLL {
    
    /// 生成蜡烛图BOLL指标数据
    /// - Parameters:
    ///   - model: 当前数据
    ///   - index: 当前数据索引
    ///   - previous: 上一条数据
    ///   - models: 当前数据所在数组
    ///   - config: 配置对象
    static func generate(models: [XLKLine.Model],
                         index: Int,
                         N: Int,
                         P: Double) {
        
        let model = models[index]
        let MA = generateMA(day: N,
                            model: model,
                            index: index,
                            models: models)
        let MD = generate(day: N,
                          models: models,
                          index: index,
                          MAValue: MA)
        model.indicator.BOLL_MB = MA
        if let MB = MA, let MD = MD {
            model.indicator.BOLL_UP = MB + P * MD
            model.indicator.BOLL_DN = MB - P * MD
        }
    }
    
    /// 生成单条蜡烛图MA指标
    /// - Parameter day: 指标参数
    /// - Parameter model: 当前数据
    /// - Parameter index: 当前数据索引
    /// - Parameter models: 当前数据所在数组
    private static func generateMA(day: Int,
                                   model: XLKLine.Model,
                                   index: Int,
                                   models: [XLKLine.Model]) -> Double? {
        
        if day <= 0 || index < (day - 1) {
            return nil
        }
        else if index == (day - 1) {
            return model.indicator.sumClose! / Double(day)
        }
        else {
            return (model.indicator.sumClose! - models[index - day].indicator.sumClose!) / Double(day)
        }
    }
    
    /// 生成单条蜡烛图MD指标
    /// - Parameters:
    ///   - day: 指标参数N天
    ///   - models: 数据模型
    ///   - index: 当前位置
    ///   - MAValue: MA数据
    /// - Returns: MD指标
    private static func generate(day: Int,
                                 models: [XLKLine.Model],
                                 index: Int,
                                 MAValue: Double?) -> Double? {
        
        guard let ma = MAValue else {
            return nil
        }
        
        if day == 0 {
            return nil
        }
        
        if models.count < day {
            return nil
        }

        var sum: Double = 0
        for index in index - day + 1 ... index {
            let model = models[index]
            sum += pow(model.close - ma, 2)
        }
        return sqrt(sum / Double(day))
    }

    /// 生成单条蜡烛图UP指标
    /// - Parameters:
    ///   - MB: MB指标
    ///   - MD: MD指标
    ///   - P: BOLL带宽度
    /// - Returns: UP指标
    private static func generateUP(MB: Double?,
                                   MD: Double?,
                                   P: Double) -> Double? {
        
        if let MB = MB,
            let MD = MD {
            return MB + P * MD
        }
        return nil
    }
    
    
    /// 生成单条蜡烛图DN指标
    /// - Parameters:
    ///   - MB: MB指标
    ///   - MD: MD指标
    ///   - P: BOLL带宽度
    /// - Returns: DN指标
    private static func generateDN(MB: Double?,
                                   MD: Double?,
                                   P: Double) -> Double? {
        
        if let MB = MB,
            let MD = MD {
            return MB - P * MD
        }
        return nil
    }
}

// MARK: - 生成绘制数据
public extension XLKLine.CandleStickBOLL {
    
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
                         config: XLKLine.Config) -> [XLKLine.CandleStickBOLL] {
        
        guard models.count > 0 else {
            
            return []
        }
        let indicatorLineWidth = config.candleStickIndicatorLineWidth
        let klineSpace = config.klineSpace
        let klineWidth = config.klineWidth
        let drawMaxY = bounds.height
        let unitValue = (limitValue.max - limitValue.min) / Double(drawMaxY)
        
        var lines: [String: XLKLine.CandleStickBOLL] = [:]
        for line in XLKLine.Model.IndicatorType.BOLLLines {
            
            let color = config.indicatorColor(type: line)
            let key = line.rawValue
            let count = models.count + leadingPreloadModels.count + trailingPreloadModels.count
            let positions = Array<CGPoint?>(repeating: nil,
                                            count: count)
            let item = XLKLine.CandleStickBOLL(positions: positions,
                                               lineColor: color,
                                               lineWidth: indicatorLineWidth)
            lines[key] = item
        }
        
        for (index, model) in leadingPreloadModels.enumerated() {
            
            let displayIndex = leadingPreloadModels.count - index - 1
            let x = -CGFloat(displayIndex) * (klineWidth + klineSpace) - klineWidth * 0.5 - klineSpace
            
            if let value = model.indicator.BOLL_DN {
                
                let key = XLKLine.Model.IndicatorType.BOLL_DN.rawValue
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue))
                let point = CGPoint(x: x, y: y)
                lines[key]?.positions[index] = point
            }
            
            if let value = model.indicator.BOLL_MB {
                
                let key = XLKLine.Model.IndicatorType.BOLL_MB.rawValue
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue))
                let point = CGPoint(x: x, y: y)
                lines[key]?.positions[index] = point
            }
            
            if let value = model.indicator.BOLL_UP {
                
                let key = XLKLine.Model.IndicatorType.BOLL_UP.rawValue
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue))
                let point = CGPoint(x: x, y: y)
                lines[key]?.positions[index] = point
            }
        }
        
 
        for (displayIndex, model) in (models + trailingPreloadModels).enumerated() {
            
            let modelIndex = leadingPreloadModels.count + displayIndex
            let x = CGFloat(displayIndex) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace
            if let value = model.indicator.BOLL_DN {
                
                let key = XLKLine.Model.IndicatorType.BOLL_DN.rawValue
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue))
                let point = CGPoint(x: x, y: y)
                lines[key]?.positions[modelIndex] = point
            }
            
            if let value = model.indicator.BOLL_MB {
                
                let key = XLKLine.Model.IndicatorType.BOLL_MB.rawValue
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue))
                let point = CGPoint(x: x, y: y)
                lines[key]?.positions[modelIndex] = point
            }
            
            if let value = model.indicator.BOLL_UP {
                
                let key = XLKLine.Model.IndicatorType.BOLL_UP.rawValue
                let y = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue))
                let point = CGPoint(x: x, y: y)
                lines[key]?.positions[modelIndex] = point
            }
        }
        return Array(lines.values)
    }
}
