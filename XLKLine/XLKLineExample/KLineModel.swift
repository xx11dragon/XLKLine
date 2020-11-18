//
//  KLineModel.swift
//  XLKLineExample
//
//  Created by xx11dragon on 2020/5/7.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import XLKLine

class KLineModel: XLKLine.Model {
    
    init(data: [Double]) {
        
        super.init(date: data[.time] ?? 0,
                   open: data[.open] ?? 0,
                   close: data[.close] ?? 0,
                   high: data[.high] ?? 0,
                   low: data[.low] ?? 0,
                   volume: data[.volume] ?? 0)
        
        
    }
}

extension Array where Element == Double {
    
    enum BarType: Int {
        case time   = 0
        case open   = 1
        case high   = 2
        case low    = 3
        case close  = 4
        case volume = 5
    }
    
    var barCount: Int {
        return 6
    }
    
    subscript(barType: BarType) -> Double? {
        set {
            guard let newValue = newValue else { return }
            let index = barType.rawValue
            if count > index {
                self[index] = newValue
            }
        }
        
        get {
            let index = barType.rawValue
            return count > index ? self[index] : nil
        }
    }
}
