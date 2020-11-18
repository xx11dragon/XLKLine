//
//  XLKLine.CandleStickBrush.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/8.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    struct CandleStickBarBrush {
        
        public static func draw(context: CGContext,
                                models: [XLKLineCandleStickBarBrushProtocol]) {

            for model in models {
                
                XLKLine.LineBrush.draw(context: context, model: model.shadow)
                XLKLine.LineBrush.draw(context: context, model: model.body)
            }
        }
    }
}

// MARK: - LineBrush协议声明
public protocol XLKLineCandleStickBarBrushProtocol {
    
    /// 阳线
    var body: XLKLineLineBrushProtocol { get }
    
    /// 阴线
    var shadow: XLKLineLineBrushProtocol { get }
    
    /// k线间隔
    var space: CGFloat { get }
    
    /// k线宽度
    var width: CGFloat { get }
}

extension XLKLineCandleStickBarBrushProtocol {
    
    public var width: CGFloat {
        
        return body.lineWidth
    }
}
