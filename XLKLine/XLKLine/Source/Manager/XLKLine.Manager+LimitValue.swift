//
//  XLKLineManager.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/11.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import Foundation

/// Manager扩展 计算边界值
extension XLKLine.Manager {
    
    public static func closeLimitValue(models: [XLKLine.Model]) -> XLKLine.LimitValue? {
        
        if models.count <= 0 {
            return nil
        }
        var minValue = models[0].close
        var maxValue = models[0].close
        
        for model in models {
            
            if model.close < minValue {
                minValue = model.close
            }
            if model.close > maxValue {
                maxValue = model.close
            }
        }
        
        if maxValue == minValue {
            maxValue += 20
            minValue -= 20
        }
        return (minValue, maxValue)
    }
    
    /// 蜡烛图计算边界值
    /// - Parameters:
    ///   - models: 数据
    ///   - indicatorType: 指标类型
    /// - Returns: 边界值
    public static func candleStickLimitValue(models: [XLKLine.Model],
                                             indicatorType: XLKLine.Model.IndicatorType) -> XLKLine.LimitValue? {
        
        if models.count <= 0 {
            return nil
        }
        var minValue = models[0].low
        var maxValue = models[0].high
        
        for model in models {
            
            if model.low < minValue {
                minValue = model.low
            }
            if model.high > maxValue {
                maxValue = model.high
            }
            // 求指标数据的最大最小
            switch indicatorType {
            case .MA:
                if let MAs = model.indicator.MA {
                    for (_, value) in MAs {
                        minValue = value < minValue ? value : minValue
                        maxValue = value > maxValue ? value : maxValue
                    }
                }
            case .BOLL:
                if let value = model.indicator.BOLL_MB {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                
                if let value = model.indicator.BOLL_UP {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                if let value = model.indicator.BOLL_DN {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
            default:
                break
            }
        }
        
        if maxValue == minValue {
            maxValue += 20
            minValue -= 20
        }
        return (minValue, maxValue)
    }
    
    /// 计算交易量边界值
    /// - Parameters:
    ///   - models: 数据
    ///   - indicatorType: 指标类型
    /// - Returns: 边界值
    public static func volumeLimitValue(models: [XLKLine.Model],
                                        indicatorType: XLKLine.Model.IndicatorType) -> XLKLine.LimitValue? {
        
        if models.count <= 0 {
            return nil
        }
        var minValue = models[0].volume
        var maxValue = models[0].volume
        for model in models {
            
            if model.volume < minValue {
                minValue = model.volume
            }
            if model.volume > maxValue {
                maxValue = model.volume
            }
            // 求指标数据的最大最小
            switch indicatorType {
            case .MA_VOLUME:
                if let MAs = model.indicator.MA_VOLUME {
                    for (_, value) in MAs {
                        minValue = value < minValue ? value : minValue
                        maxValue = value > maxValue ? value : maxValue
                    }
                }
            default:
                break
            }
        }
        
        return (minValue, maxValue)
    }
    
    /// 副视图指标边界值
    /// - Parameters:
    ///   - models: 数据
    ///   - indicatorType: 指标类型
    /// - Returns: 边界值
    public static func accessoryLimitValue(models: [XLKLine.Model],
                                           indicatorType: XLKLine.Model.IndicatorType) -> XLKLine.LimitValue? {
        
        if models.count <= 0 {
            return nil
        }
        
        var minValue = 0.0
        var maxValue = 0.0
        for model in models {
            switch indicatorType {
            case .MACD:
                
                if let value = model.indicator.DIF {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                if let value = model.indicator.DEA {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                if let value = model.indicator.MACD {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                
                
            case .KDJ:
                
                
                if let value = model.indicator.KDJ_K {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                
                if let value = model.indicator.KDJ_D {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                if let value = model.indicator.KDJ_J {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                
            case .RSI:
                if let RSIs = model.indicator.RSI {
                    for (_, value) in RSIs {
                        minValue = value < minValue ? value : minValue
                        maxValue = value > maxValue ? value : maxValue
                    }
                }
            case .WR:
                if let WRs = model.indicator.WR {
                    for (_, value) in WRs {
                        minValue = value < minValue ? value : minValue
                        maxValue = value > maxValue ? value : maxValue
                    }
                }
            default:
                break
            }
        }
        return (minValue, maxValue)
    }
}
