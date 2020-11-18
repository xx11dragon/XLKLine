//
//  XLKLine.Model.Indicator.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/4/23.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import Foundation

public extension XLKLine.Model {
    
    struct Indicator {
        // MARK: 开高低收之和 -
        // 所有开盘价之和 O1+O2+……ON O:开盘价
        var sumOpen: Double?
        
        // 所有收盘价之和 C1+C2+……CN C:开盘价
        var sumClose: Double?
        
        // 所有最高价之和 H1+H2+……HN H:最高价
        var sumHigh: Double?
        
        // 所有最低价之和 L1+L2+……LN L:最高价
        var sumLow: Double?
        
        // 所有成交量之和 V1+V2+……VN V:最高价
        var sumVolume: Double?
        
        // MARK: MA指标 -
        //  MA(N) = (C1+C2+……CN) / N, C:收盘价
        var MA: [String: Double]?
        //  MA(N) = (C1+C2+……CN) / N, C:交易量
        var MA_VOLUME: [String: Double]?
        
        // MARK: MACD指标 -
        //  EMA(S) = 前一日EMA（S）× (S - 1) / (S + 1)+ 今日收盘价 × 2 / (S + 1)
        var EMA_S: Double?
        //  EMA(L) = 前一日EMA（S）× (S - 1) / (S + 1)+ 今日收盘价 × 2 / (S + 1)
        var EMA_L: Double?
        // DIF = EMA(S) - EMA(L)
        var DIF: Double?
        // DEA = 今日DIF x 2 / (M + 1) + 前一日DEA x (M - 1) / (M + 1)
        var DEA: Double?
        // MACD = (DIF - DEA) * 2
        var MACD: Double?
        
        // MARK: KDJ指标 -
        // RSV(N) =（今日收盘价 － N日内最低价）/（N日内最高价 － N日内最低价）x 100
        var KDJ_RSV: Double?
        // K(3) =（当日RSV值 + 2 x 前一日K值）/ 3
        var KDJ_K: Double?
        // D(3) =（当日K值 + 2 x 前一日D值）/ 3
        var KDJ_D: Double?
        // J = 3 x K － 2 x D
        var KDJ_J: Double?
        
        // MARK: BOLL
        // 中轨线 MB = N日的MA
        var BOLL_MB: Double?
        // 上轨线 UP = MB+2×MD
        var BOLL_UP: Double?
        // 下轨线 DN = MB－2×MD
        var BOLL_DN: Double?
        // MARK: - RSI
        var RSI: [String: Double]?
        
        var RSIMaxEMA: [String: Double] = [:]
        
        var RSIAbsEMA: [String: Double] = [:]
        // MARK: - WR
        var WR: [String: Double]?
    }
}

