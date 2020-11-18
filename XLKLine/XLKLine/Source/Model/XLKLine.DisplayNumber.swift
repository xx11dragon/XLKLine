//
//  XLKLine.DisplayNumber.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/6/24.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import Foundation

extension XLKLine {
    
    /// 显示小数（保留小数位数）
    /// - Parameters:
    ///   - number: 小数值
    ///   - minDigits: 小数点后最小位数
    ///   - maxDigits: 小数点后最大数位
    /// - Returns: 显示小数
    static func display(number: Double,
                        minimumFractionDigits: Int,
                        maximumFractionDigits: Int) -> String? {
        
        let number = NSDecimalNumber(value: number)
        let formatter = NumberFormatter()
        formatter.roundingMode = .down
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(from: number)
    }
}
