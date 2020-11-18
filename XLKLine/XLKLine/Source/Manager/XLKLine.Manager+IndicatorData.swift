//
//  XLKLine.Manager+IndicatorData.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/11.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import Foundation

/// Manager扩展 计算指标数据
extension XLKLine.Manager {
    
    
    /// 生成各个指标数据
    /// - Parameters:
    ///   - models: 数据
    ///   - config: 自定义配置对象
    func generateIndicatorData(models: [XLKLine.Model],
                               config: XLKLine.Config) {
        
        var previous: XLKLine.Model?
        for index in 0 ..< models.count {
            
            models[index].indicator.sumClose = models[index].close + (previous?.indicator.sumClose ?? 0)
            models[index].indicator.sumVolume = models[index].volume + (previous?.indicator.sumVolume ?? 0)
            //  计算蜡烛图MA指标
            XLKLine.CandleStickMA.generate(models: models,
                                           index: index,
                                           days: config.candleStickMADays)
            //  计算蜡烛图BOLL指标
            XLKLine.CandleStickBOLL.generate(models: models,
                                             index: index,
                                             N: config.candleStickBOLLN,
                                             P: config.candleStickBOLLP)
            //  计算Volume MA指标
            XLKLine.VolumeMA.generate(models: models,
                                      index: index,
                                      days: config.volumeMADays)
            //  计算副视图MACD指标
            XLKLine.AccessoryMACD.generate(models: models,
                                           index: index,
                                           S: config.accessoryMACDS,
                                           L: config.accessoryMACDL,
                                           M: config.accessoryMACDM)
            //  计算副视图KDJ指标
            XLKLine.AccessoryKDJ.generate(models: models,
                                          index: index,
                                          N: config.accessoryKDJN,
                                          M1: config.accessoryKDJM1,
                                          M2: config.accessoryKDJM2)
            //  计算副视图RSI指标
            XLKLine.AccessoryRSI.generate(models: models,
                                          index: index,
                                          days: config.accessoryRSI)
            //  计算副视图WR指标
            XLKLine.AccessoryWR.generate(models: models,
                                         index: index,
                                         days: config.accessoryWR)
            previous = models[index]
        }
        
        XLKLine.AccessoryMACD.removeInaccurateData(models: models,
                                                   L: config.accessoryMACDL,
                                                   M: config.accessoryMACDM)
    }
}
