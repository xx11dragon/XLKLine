//
//  XLKLine.AccessoryKDJ.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/6/5.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    public struct AccessoryKDJ: XLKLineLineBrushProtocol {
        
        public var positions: XLKLine.Positions
        
        public var lineColor: UIColor
        
        public var lineWidth: CGFloat
    }
}

extension XLKLine.AccessoryKDJ {
    
    public typealias Response = (
        K: XLKLineLineBrushProtocol,
        D: XLKLineLineBrushProtocol,
        J: XLKLineLineBrushProtocol
    )
}

// MARK: - 生成数据
extension XLKLine.AccessoryKDJ {
    
    static func generate(models: [XLKLine.Model],
                         index: Int,
                         N: Int,
                         M1: Int,
                         M2: Int) {
        
        if index < 0 || models.count <= index {
            return
        }
        let previous = index > 0 ? models[index - 1] : nil
        let RSV = generateRSV(models: models, index: index, N: N)
        let K = generateK(RSV: RSV, previous: previous, M1: M1)
        let D = generateD(K: K, previous: previous, M2: M2)
        let J = generateJ(K: K, D: D)
        let model = models[index]
        model.indicator.KDJ_K = K
        model.indicator.KDJ_D = D
        model.indicator.KDJ_J = J
    }
    
    static func generateLN(models: [XLKLine.Model],
                           index: Int,
                           N: Int) -> Double {
        
        var minLow = models[index].low
        let startIndex = max(index - N + 1, 0)
        for index in startIndex ..< index {
            if models[index].low < minLow {
                minLow = models[index].low
            }
        }
        return minLow
    }
    
    static func generateHN(models: [XLKLine.Model],
                           index: Int,
                           N: Int) -> Double {
        
        var maxHigh = models[index].high
        let startIndex = max(index - N + 1, 0)
        for index in startIndex ..< index {
            if maxHigh < models[index].high {
                maxHigh = models[index].high
            }
        }
        return maxHigh
    }
    
    /// 计算RSV (CN - LN) / (HN - LN) * 100    CN: 第N日收盘价 LN: N日内的最低价 HN: N日内的最高价 RSV值范围1—100
    /// - Parameters:
    ///   - models: 数据源
    ///   - index: 当前位置
    ///   - N: N天
    /// - Returns: RSV
    static func generateRSV(models: [XLKLine.Model],
                           index: Int,
                           N: Int) -> Double {
        
        let LN = generateLN(models: models, index: index, N: N)
        let HN = generateHN(models: models, index: index, N: N)
        let CN = models[index].close
        return (CN - LN) / (HN - LN) * 100
    }
    
    static func generateK(RSV: Double,
                          previous: XLKLine.Model?,
                          M1: Int) -> Double {

        let k = previous?.indicator.KDJ_K ?? 50
        let M1 = Double(M1)
        return sma(previous: k, X: RSV, N: M1, M: 1)
    }
    
    static func generateD(K: Double,
                          previous: XLKLine.Model?,
                          M2: Int) -> Double {

        let d = previous?.indicator.KDJ_D ?? 50
        let M2 = Double(M2)
        return sma(previous: d, X: K, N: M2, M: 1)
    }
    
    static func generateJ(K: Double,
                          D: Double) -> Double {
        
        return 3 * K - 2 * D
    }
    
    static func sma(previous: Double, X: Double, N: Double, M: Double) -> Double {
        
        return (M * X + (N - M) * previous) / N
    }
}

// MARK: - 生成数据
public extension XLKLine.AccessoryKDJ {
    
    /// 生成副视图KDJ指标
    /// - Parameter model: 当前数据
    /// - Parameter index: 当前数据索引
    /// - Parameter previous: 上一条数据
    static func generate(models: [XLKLine.Model],
                         leadingPreloadModels: [XLKLine.Model],
                         trailingPreloadModels: [XLKLine.Model],
                         bounds: CGRect,
                         limitValue: XLKLine.LimitValue,
                         config: XLKLine.Config) -> XLKLine.AccessoryKDJ.Response {
        
        let klineWidth = config.klineWidth
        let klineSpace = config.klineSpace
        let paddingTop = config.accessoryContentInset.top
        let drawMaxY = bounds.height - paddingTop
        let unitValue = (limitValue.max - limitValue.min) / Double(drawMaxY)
        
        
        var kPoints: [CGPoint] = []
        var dPoints: [CGPoint] = []
        var jPoints: [CGPoint] = []
        
        for (index, model) in leadingPreloadModels.enumerated() {
            
            let displayIndex = leadingPreloadModels.count - index - 1
            let x = -CGFloat(displayIndex) * (klineWidth + klineSpace) - klineWidth * 0.5 - klineSpace
            if let value = model.indicator.KDJ_K {

                let y: CGFloat = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                kPoints.append(point)
            }
            if let value = model.indicator.KDJ_D {
                
                let y: CGFloat = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                dPoints.append(point)
            }
            if let value = model.indicator.KDJ_J {
                
                let y: CGFloat = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                jPoints.append(point)
            }  
        }

        for (displayIndex, model) in (models + trailingPreloadModels).enumerated() {
            
            let x = CGFloat(displayIndex) * (klineWidth + klineSpace) + klineWidth * 0.5 + klineSpace
            if let value = model.indicator.KDJ_K {

                let y: CGFloat = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                kPoints.append(point)
            }
            if let value = model.indicator.KDJ_D {
                
                let y: CGFloat = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                dPoints.append(point)
            }
            if let value = model.indicator.KDJ_J {
                
                let y: CGFloat = abs(drawMaxY - CGFloat((value - limitValue.min) / unitValue)) + paddingTop
                let point = CGPoint(x: x, y: y)
                jPoints.append(point)
            }
        }
        let kColor = config.accessoryKDJKColor
        let dColor = config.accessoryKDJDColor
        let jColor = config.accessoryKDJJColor
        let indicatorLineWidth = config.accessoryIndicatorLineWidth
        
        let k = XLKLine.AccessoryKDJ(positions: kPoints,
                                     lineColor: kColor,
                                     lineWidth: indicatorLineWidth)
        let d = XLKLine.AccessoryKDJ(positions: dPoints,
                                     lineColor: dColor,
                                     lineWidth: indicatorLineWidth)
        let j = XLKLine.AccessoryKDJ(positions: jPoints,
                                     lineColor: jColor,
                                     lineWidth: indicatorLineWidth)

        return XLKLine.AccessoryKDJ.Response(K: k,
                                             D: d,
                                             J: j)
    }
}
