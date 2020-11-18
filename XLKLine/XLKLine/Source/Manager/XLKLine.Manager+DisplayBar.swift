//
//  XLKLine.Manager+Display.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/19.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

// MARK: - 有关显示蜡烛图方法
public extension XLKLine.Manager {

    /// 显示K线数量
    /// - Parameters:
    ///   - displayWidth: 显示宽度
    ///   - modelsCount: 数据数量
    ///   - currentLocation: 当前位置
    ///   - config: 配置对象
    /// - Returns: 显示K线数量
    static func displayBarCount(displayWidth: CGFloat,
                                modelsCount: Int,
                                currentLocation: Int,
                                config: XLKLine.Config) -> Int {
        
        if modelsCount == 0 { //  数据为空
            return 0
        }
        
        let minCount = minDisplayBarCount(displayWidth: displayWidth,
                                          config: config)
        let maxCount = maxDisplayBarCount(displayWidth: displayWidth,
                                          config: config)
        if modelsCount < minCount { //  数据数量 小于 最小显示数量
            
            return modelsCount
        }
        if modelsCount - maxCount < currentLocation {
            return modelsCount - currentLocation
        } else {
            return maxCount
        }
    }
    
    /// 截取显示的模型
    /// - Parameters:
    ///   - models: 模型
    ///   - displayWidth: 显示宽度
    ///   - currentLocation: 当前位置
    ///   - config: 显示模型
    static func displayBarModels(models:[XLKLine.Model],
                                 displayWidth: CGFloat,
                                 currentLocation: Int,
                                 config: XLKLine.Config) -> [XLKLine.Model] {
        
        if models.count == 0 {
            
            return []
        }
        let displayCount = XLKLine.Manager.displayBarCount(displayWidth: displayWidth,
                                                           modelsCount: models.count,
                                                           currentLocation: currentLocation,
                                                           config: config)
        let displayRange = NSRange(location: currentLocation,
                                   length: displayCount)
        guard displayRange.location + displayRange.length <= models.count &&
            displayRange.location >= 0 else {
                
                return []
        }
        guard let range = Range(displayRange) else {
            
            return []
        }
        return Array(models[range])
    }
}
