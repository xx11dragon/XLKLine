//
//  XLKLine.Manager+Display.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/6/12.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

// MARK: - 有关显示的公共方法
public extension XLKLine.Manager {
    
    /// 显示数量 leadingOffset: 左预加载数量 displayCount: 显示数量 trailingOffset: 右预加载数量
    typealias DisplayCount = (leadingPreloadCount: Int, count: Int, trailingPreloadCount: Int)
    
    /// 显示数据 leadingOffset: 左预加载数据 displayCount: 显示数据 trailingOffset: 右预加载数量
    typealias DisplayModel = (leadingPreloadModels: [XLKLine.Model], models: [XLKLine.Model], trailingPreloadModels: [XLKLine.Model])
    
    /// K线最小显示宽度
    /// - Parameter bounds: 显示宽度
    /// - Parameter config: 配置对象
    /// - Returns: 显示宽度
    static func minDisplayBarWidth(displayWidth: CGFloat,
                                   config: XLKLine.Config) -> CGFloat {
        
        let count = CGFloat(config.verticalAxisScaleLineCount)
        return displayWidth * count / CGFloat(count + 1)
    }
    
    /// K线最大显示宽度
    /// - Parameter displayWidth: 显示宽度
    /// - Returns: K线显示宽度
    static func maxDispalyBarWidth(displayWidth: CGFloat) -> CGFloat {
        return displayWidth
    }
    
    /// K线最小显示数量
    /// - Parameters:
    ///   - displayWidth: 显示宽度
    ///   - config: 配置对象
    /// - Returns: K线最小显示数量
    static func minDisplayBarCount(displayWidth: CGFloat,
                                   config: XLKLine.Config) -> Int {
        
        let width = minDisplayBarWidth(displayWidth: displayWidth, config: config)
        let unitSpace = config.klineWidth + config.klineSpace
        return Int(width / unitSpace)
    }
    
    /// K线最大显示数量
    /// - Parameters:
    ///   - displayWidth: 显示宽度
    ///   - config: 配置对象
    /// - Returns: K线最大显示数量
    static func maxDisplayBarCount(displayWidth: CGFloat,
                                   config: XLKLine.Config) -> Int {
        
        let width = maxDispalyBarWidth(displayWidth: displayWidth)
        let unitSpace = config.klineWidth + config.klineSpace
        return Int(width / unitSpace)
    }
    
    /// 计算默认显示位置
    /// - Parameters:
    ///   - displayWidth: 显示宽度
    ///   - modelsCount: 模型数量
    ///   - config: 配置对象
    /// - Returns: 当前位置
    static func defaultLocation(displayWidth: CGFloat,
                                modelsCount: Int,
                                currentLocation: Int,
                                config: XLKLine.Config) -> Int {
        
        if modelsCount == 0 { //  数据为空
            return 0
        }
        
        let minCount = minDisplayBarCount(displayWidth: displayWidth,
                                          config: config)
        if modelsCount < minCount { //  数据数量 小于 最小显示数量
            
            return 0
        }
        return max(modelsCount - minCount - 1, 0)
    }
}
