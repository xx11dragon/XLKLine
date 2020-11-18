//
//  XLKLine.Manager.DisplayIndicator.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/6/12.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

// MARK: - 有关显示指标方法
public extension XLKLine.Manager {
    
    /// 显示指标数量
    /// - Parameters:
    ///   - displayWidth: 显示宽度
    ///   - modelsCount: 数据数量
    ///   - currentLocation: 当前位置
    ///   - config: 配置对象
    /// - Returns: 显示K线数量
    static func displayIndicatorCount(displayWidth: CGFloat,
                                      modelsCount: Int,
                                      currentLocation: Int,
                                      config: XLKLine.Config) -> DisplayCount {
        
        if modelsCount == 0 { //  数据为空
            return (0, 0, 0)
        }
        let minCount = minDisplayBarCount(displayWidth: displayWidth,
                                          config: config)
        let maxCount = maxDisplayBarCount(displayWidth: displayWidth,
                                          config: config)
        let displayCount = modelsCount - maxCount < currentLocation ? modelsCount - currentLocation : maxCount
        let leadingPreloadCount = max(0, min(currentLocation, config.indicatorLeadingPreloadCount))
        let trailingPreloadCount = max(0, min(modelsCount - currentLocation - displayCount, config.indicatorTrailingPreloadCount))
        if modelsCount < minCount { //  数据数量 小于 最小显示数量
            
            return (leadingPreloadCount, modelsCount, trailingPreloadCount)
        }
        
        return (leadingPreloadCount, displayCount, trailingPreloadCount)
    }
    
    /// 截取显示的模型
    /// - Parameters:
    ///   - models: 模型
    ///   - displayWidth: 显示宽度
    ///   - currentLocation: 当前位置
    ///   - config: 显示模型
    /// - Returns: <#description#>
    static func displayIndicatorModels(models:[XLKLine.Model],
                                       displayWidth: CGFloat,
                                       currentLocation: Int,
                                       config: XLKLine.Config) -> DisplayModel {
        
        if models.count == 0 {
            
            return ([], [], [])
        }
        let display = XLKLine.Manager.displayIndicatorCount(displayWidth: displayWidth,
                                                            modelsCount: models.count,
                                                            currentLocation: currentLocation,
                                                            config: config)
        let leadingPreloadLocation = currentLocation - display.leadingPreloadCount
        let leadingPreloadLength = display.leadingPreloadCount
        
        let trailingPreloadLocation = currentLocation + display.count
        let trailingPreloadLength = display.trailingPreloadCount

        let displayRange = NSRange(location: currentLocation,
                                   length: display.count)
        let leadingPreloadRange = NSRange(location: leadingPreloadLocation,
                                          length: leadingPreloadLength)
        let trailingPreloadRange = NSRange(location: trailingPreloadLocation,
                                           length: trailingPreloadLength)

        //  显示 range 是否越界
        guard displayRange.location + displayRange.length <= models.count &&
            displayRange.location >= 0, let range = Range(displayRange) else {
                
                return ([], [], [])
        }
        //  计算左侧预加载数据
        var leadingPreloadModels: [XLKLine.Model] = []
        if leadingPreloadRange.location + leadingPreloadRange.length <= models.count &&
            leadingPreloadRange.location >= 0, let range = Range(leadingPreloadRange)  {
            
            leadingPreloadModels = Array(models[range])
        }
        //  计算右侧预加载数据
        var trailingPreloadModels: [XLKLine.Model] = []
        if trailingPreloadRange.location + trailingPreloadRange.length <= models.count &&
            trailingPreloadRange.location >= 0, let range = Range(trailingPreloadRange)  {
            
            trailingPreloadModels = Array(models[range])
        }
        return (leadingPreloadModels, Array(models[range]), trailingPreloadModels)
    }
}
