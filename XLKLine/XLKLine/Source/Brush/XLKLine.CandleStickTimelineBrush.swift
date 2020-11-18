//
//  XLKLine.CandleStickTimelineBrush.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/6/22.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    struct CandleStickTimelineBrush {
        
        public static func draw(bounds: CGRect,
                                model: CandleStickTimeline) -> CALayer {

            let lineLayer = CAShapeLayer()
            if model.positions.isEmpty {
                return lineLayer
            }
            
            var positions: [CGPoint] = []
            model.positions.forEach {
      
                $0 != nil ? positions.append($0!) : nil
            }

            let linePath = XLKLine.BezierBrush.bezierPath(models: positions)
            linePath.lineWidth = model.lineWidth
            
            let firstX = positions.first?.x ?? 0
            let lastX = positions.last?.x ?? 0

            lineLayer.path = linePath.cgPath
            lineLayer.lineWidth = model.lineWidth
            lineLayer.strokeColor = model.lineColor.cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            
            linePath.addLine(to: CGPoint(x: lastX, y: bounds.height))
            linePath.addLine(to: CGPoint(x: firstX, y: bounds.height))

            let fillLayer = CAShapeLayer()
            fillLayer.path = linePath.cgPath
            
            let gradualLayer = CAGradientLayer()
            gradualLayer.mask = fillLayer
            gradualLayer.frame = bounds
            gradualLayer.colors = [model.fillGradualTopColor.cgColor,
                                   model.fillGradualBottomColor.cgColor]

            lineLayer.addSublayer(gradualLayer)

            return lineLayer
        }
    }
}
