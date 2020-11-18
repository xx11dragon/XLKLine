//
//  XLKLine.AccessoryMACD.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/29.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine.AccessoryMACD {
    
    public typealias Response = (
        MACD: [XLKLineLineBrushProtocol],
        DIF: XLKLine.LineBrush.Model,
        DEA: XLKLine.LineBrush.Model
    )
}

extension XLKLine {
    
    public struct AccessoryMACD: XLKLineLineBrushProtocol {
        
        public var positions: XLKLine.Positions
        
        public var lineColor: UIColor
        
        public var lineWidth: CGFloat
    }
    
    public struct AccessoryDIF:  XLKLineLineBrushProtocol {
        
        public var positions: XLKLine.Positions
        
        public var lineColor: UIColor
        
        public var lineWidth: CGFloat
    }
    
    public struct AccessoryDEA:  XLKLineLineBrushProtocol {
        
        public var positions: XLKLine.Positions
        
        public var lineColor: UIColor
        
        public var lineWidth: CGFloat
    }
}

extension XLKLine.AccessoryMACD {
    
    /// 生成副视图MACD指标
    /// - Parameter model: 当前数据
    /// - Parameter index: 当前数据索引
    /// - Parameter previous: 上一条数据
    static func generate(models: [XLKLine.Model],
                         index: Int,
                         S: Int,
                         L: Int,
                         M: Int) {

        if index < 0 || models.count <= index {
            return
        }

        let current: XLKLine.Model = models[index]
        let previous: XLKLine.Model? = index > 0 ? models[index - 1] : nil

        let emaS = generateEMA(day: S,
                               model: current,
                               index: index,
                               previousEMA: previous?.indicator.EMA_S)
        let emaL = generateEMA(day: L,
                               model: current,
                               index: index,
                               previousEMA: previous?.indicator.EMA_L)

        current.indicator.DIF = generateDIF(S: emaS,
                                            L: emaL)
        current.indicator.DEA = generateDEA(current: current,
                                            previous: previous,
                                            M: M)
        current.indicator.MACD = generateMACD(model: current)
        current.indicator.EMA_S = emaS
        current.indicator.EMA_L = emaL
    }
    
    /// 生成单条副视图EMA指标
    /// - Parameter day: 指标参数
    /// - Parameter model: 当前数据
    /// - Parameter index: 当前数据索引
    /// - Parameter previousEMA: 前一条EMA数据
    private static func generateEMA(day: Int,
                                    model: XLKLine.Model,
                                    index: Int,
                                    previousEMA: Double?) -> Double? {
        
        if index <= 0 {
            
            return model.close
        }
        
        if let previousEMA = previousEMA {

            return previousEMA * Double(day - 1) / Double(day + 1) + model.close * 2 / Double(day + 1)
        } else {
            return model.close * 2 / Double(day + 1)
        }
    }
    
    /// 生成单条副视图DIF指标
    /// - Parameter S: EMA数据
    /// - Parameter L: EMA数据
    private static func generateDIF(S: Double?,
                                    L: Double?) -> Double? {
        
        guard let S = S,
            let L = L else {
                return nil
        }
        return S - L
    }
    
    
    /// DEA指标: DEA(M) = DIF * 2 / (M + 1) + DEA * (M - 1) / (M + 1)
    /// - Parameters:
    ///   - current: 当前数据
    ///   - previous: 上一条数据
    ///   - M: M参数
    /// - Returns: DEA数据
    private static func generateDEA(current: XLKLine.Model,
                                    previous: XLKLine.Model?,
                                    M: Int) -> Double? {
        
        guard let dif = current.indicator.DIF else {
            return nil
        }
        let previousDEA = previous?.indicator.DEA ?? 0
        return dif * 2 / Double(M + 1) + previousDEA * Double(M - 1) / Double(M + 1)
    }
    
    /// 生成单条副视图MACD指标
    /// - Parameter model: 当前数据
    private static func generateMACD(model: XLKLine.Model) -> Double? {
        
        guard let dif = model.indicator.DIF,
            let dea = model.indicator.DEA else {
                
                return nil
        }
        return (dif - dea) * 2
    }
}

// MARK: - 生成绘制数据
public extension XLKLine.AccessoryMACD {
    
    /// 生成MACD绘制数据
    /// - Parameter models: 数据
    /// - Parameter bounds: 显示区域尺寸
    /// - Parameter limitValue: 边界值
    /// - Parameter config: 配置对象
    static func generate(models: [XLKLine.Model],
                         leadingPreloadModels: [XLKLine.Model],
                         trailingPreloadModels: [XLKLine.Model],
                         bounds: CGRect,
                         limitValue: XLKLine.LimitValue,
                         config: XLKLine.Config) -> Response {

        let klineWidth = config.klineWidth
        let klineSpace = config.klineSpace
        let increaseColor = config.increaseColor
        let decreaseColor = config.decreaseColor
        let paddingTop = config.accessoryContentInset.top
        let drawMaxY = bounds.height - paddingTop
        let unitValue = (limitValue.max - limitValue.min) / Double(drawMaxY)
        let middleY = drawMaxY - CGFloat(abs(limitValue.min) / unitValue) + paddingTop
        
        var macd: [XLKLineLineBrushProtocol] = []
        var difPoints: XLKLine.Positions = []
        var deaPoints: XLKLine.Positions = []
        

        
        for (index, model) in models.enumerated() {
            
            let x = CGFloat(index) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace
            var top = middleY
            var bottom = middleY
            
            if let macdValue = model.indicator.MACD {

                let offsetValue = CGFloat(abs(macdValue) / unitValue)
                top = macdValue >= 0 ? middleY - offsetValue : middleY
                bottom = macdValue >= 0 ? middleY : middleY + offsetValue
                let color = macdValue >= 0 ? increaseColor : decreaseColor
                
                let startPoint = CGPoint(x: x,
                                         y: top)
                let endPoint = CGPoint(x: x,
                                       y: bottom)
                let model = XLKLine.LineBrush.Model(positions: [startPoint, endPoint],
                                                    lineColor: color,
                                                    lineWidth: klineWidth)
                macd.append(model)
            }
//            if let value = model.indicator.DIF {
//
//                let x = CGFloat(index) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace
//                let y = CGFloat(-(value) / unitValue) + middleY
//                difPoints.append(CGPoint(x: x, y: y))
//            }
//            if let value = model.indicator.DEA {
//
//                let x = CGFloat(index) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace
//                let y = CGFloat(-(value) / unitValue) + middleY
//                deaPoints.append(CGPoint(x: x, y: y))
//            }
        }
        
        for (index, model) in leadingPreloadModels.enumerated() {
            
            let displayIndex = leadingPreloadModels.count - index - 1
            if let value = model.indicator.DIF {
                
                let x = -CGFloat(displayIndex) * (klineWidth + klineSpace) - klineWidth * 0.5 - klineSpace
                let y = CGFloat(-(value) / unitValue) + middleY
                difPoints.append(CGPoint(x: x, y: y))
            }
            if let value = model.indicator.DEA {
                
                let x = -CGFloat(displayIndex) * (klineWidth + klineSpace) - klineWidth * 0.5 - klineSpace
                let y = CGFloat(-(value) / unitValue) + middleY
                deaPoints.append(CGPoint(x: x, y: y))
            }
        }
        
        for (displayIndex, model) in (models + trailingPreloadModels).enumerated() {
            
            if let value = model.indicator.DIF {
                
                let x = CGFloat(displayIndex) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace
                let y = CGFloat(-(value) / unitValue) + middleY
                difPoints.append(CGPoint(x: x, y: y))
            }
            if let value = model.indicator.DEA {
                
                let x = CGFloat(displayIndex) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace
                let y = CGFloat(-(value) / unitValue) + middleY
                deaPoints.append(CGPoint(x: x, y: y))
            }
        }

        let difColor = config.accessoryMACDDIFColor
        let deaColor = config.accessoryMACDDEAColor
        let indicatorLineWidth = config.accessoryIndicatorLineWidth
        
        
        let dea = XLKLine.LineBrush.Model(positions: deaPoints,
                                          lineColor: deaColor,
                                          lineWidth: indicatorLineWidth)
        let dif = XLKLine.LineBrush.Model(positions: difPoints,
                                          lineColor: difColor,
                                          lineWidth: indicatorLineWidth)
        return (macd, dif, dea)
    }
}

// MARK: - 删除不准确数据（数据开始时计算不准确）
public extension XLKLine.AccessoryMACD {
    
    static func removeInaccurateData(models: [XLKLine.Model],
                                     L: Int,
                                     M: Int) {
        
        for index in 0 ..< min(L + M - 1, models.count) {
            let model = models[index]
            if index < L {
                model.indicator.DIF = nil
            }
            model.indicator.MACD = nil
            model.indicator.DEA = nil
        }
    }
}
