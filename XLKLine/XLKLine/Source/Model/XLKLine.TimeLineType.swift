//
//  XLKLine.TimeLineType.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/6/17.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import Foundation

public extension XLKLine {
    
    enum TimeLineType: Int {
        
        case timeline       = 1 // 分时
        case oneMinute      = 2 // 1分
        case fiveMinute     = 3 // 5分
        case fifteenMinute  = 4 // 15分
        case thirtyMinute   = 5 // 30分
        case oneHour        = 6 // 60分
        case oneDay         = 7 // 日
        case oneWeek        = 8 // 周
        case oneMonth       = 9 // 月
        
        /// 日期格式
        func dateFormat(config: Config) -> String  {
            
            switch self {
            case .timeline:
                return config.realTimeDateFormat
            case .oneMinute, .fiveMinute, .fifteenMinute, .thirtyMinute, .oneHour:
                return config.minuteDateFormat
            case .oneDay, .oneWeek, .oneMonth:
                return config.monthDateFormat
            }
        }
    }
}
