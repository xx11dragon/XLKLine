//
//  XLKLine.Model.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/4/23.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import Foundation

extension XLKLine {
    
    /// K线基础模型
    open class Model {
        
        /// 日期
        var date: Double
        /// 开盘价
        var open: Double
        /// 收盘价
        var close: Double
        /// 最高价
        var high: Double
        /// 最低价
        var low: Double
        /// 成交量
        var volume: Double
        /// 指标
        var indicator: Indicator = Indicator()
        
        public init(date: Double,
                    open: Double,
                    close: Double,
                    high: Double,
                    low: Double,
                    volume: Double) {
            
            self.date = date
            self.open = open
            self.close = close
            self.high = high
            self.low = low
            self.volume = volume
        }
    }
}

extension XLKLine.Model {
    
    /// 显示时间
    /// - Parameters:
    ///   - format: 时间格式
    ///   - timestampType: 时间戳类型
    /// - Returns: 时间
    public func displayDate(format: String,
                            timestampType: XLKLine.TimestampType) -> String {

        let date = Date(timeIntervalSince1970: self.date / Double(timestampType.rawValue))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
