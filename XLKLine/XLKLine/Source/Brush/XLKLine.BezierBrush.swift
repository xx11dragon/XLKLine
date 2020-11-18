//
//  XLKLine.BezierBrush.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/6/18.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    struct BezierBrush {
        
        public static func bezierPath(models: [CGPoint]) -> UIBezierPath {
            
            if models.isEmpty {
                
                return UIBezierPath()
            }
            
            let lineSmoothness: CGFloat = 0.15
            let path = UIBezierPath()
            
            var prePreviousPoint: CGPoint?
            var previousPoint: CGPoint?
            var currentPoint: CGPoint?
            var nextPoint: CGPoint?

            var maxY: CGFloat = models[0].y
            var minY: CGFloat = models[0].y
            for model in models {
                
                if model.y > maxY {
                    maxY = model.y
                }
                
                if model.y < minY {
                    minY = model.y
                }
            }

            for (index, model) in models.enumerated() {
   
                if currentPoint == nil {
                    currentPoint = model
                }
                if previousPoint == nil {
                    previousPoint = index > 0 ? models[index - 1] : model
                }
                if prePreviousPoint == nil {
                    prePreviousPoint = index > 1 ? models[index - 2] : previousPoint
                }
                nextPoint = index < models.count - 1 ? models[index + 1] : model
   
                if index == 0 {
                    path.move(to: model)
                } else {
                    guard let prePreviousPoint = prePreviousPoint,
                        let previousPoint = previousPoint,
                        let currentPoint = currentPoint,
                        let nextPoint = nextPoint else {

                        continue
                    }
                    let firstDiff = CGPoint(x: currentPoint.x - prePreviousPoint.x,
                                            y: currentPoint.y - prePreviousPoint.y)
                    let secondDiff = CGPoint(x: nextPoint.x - previousPoint.x,
                                             y: nextPoint.y - previousPoint.y)
                    
                    var firstControl = CGPoint(x: previousPoint.x + lineSmoothness * firstDiff.x,
                                              y: previousPoint.y + lineSmoothness * firstDiff.y)
                    var secondControl = CGPoint(x: currentPoint.x - lineSmoothness * secondDiff.x,
                                                y: currentPoint.y - lineSmoothness * secondDiff.y)
                    firstControl.y = max(min(firstControl.y, maxY), minY)
                    secondControl.y = max(min(secondControl.y, maxY), minY)
                    path.addCurve(to: currentPoint,
                                      controlPoint1: firstControl,
                                      controlPoint2: secondControl)
                }
                
                prePreviousPoint = previousPoint
                previousPoint = currentPoint
                currentPoint = nextPoint
            }
            return path
        }
    }
}
