//
//  XLKLineLineBrush.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/7.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

public extension XLKLine {
    
    /// 绘制线工具
    struct LineBrush {
        
        /// 绘制
        /// - Parameter context: 绘制板
        /// - Parameter model: 绘制数据
        static func draw(context: CGContext,
                         model: XLKLineLineBrushProtocol) {
            
            let lineWidth = model.lineWidth
            let lineColor = model.lineColor
            context.setLineWidth(lineWidth)
            context.setStrokeColor(lineColor.cgColor)
            
            var firstPoint: CGPoint?
            for (point) in model.positions {

                guard let point = point else {
                    
                    continue
                }
                if firstPoint == nil {
                    
                    firstPoint = point
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
            context.strokePath()
        }
    }
}

// MARK: - LineBrush协议声明
public protocol XLKLineLineBrushProtocol {
    
    /// line坐标
    var positions: XLKLine.Positions { set get }
    
    /// 绘制线颜色
    var lineColor: UIColor { get }
    
    /// 绘制线宽度
    var lineWidth: CGFloat { get }
}



// MARK: - LineBrush模型
public extension XLKLine.LineBrush {
    
    /// LineBrush模型
    struct Model: XLKLineLineBrushProtocol {

        public var positions: [CGPoint?]
        
        public var lineColor: UIColor
        
        public var lineWidth: CGFloat
    }
}
