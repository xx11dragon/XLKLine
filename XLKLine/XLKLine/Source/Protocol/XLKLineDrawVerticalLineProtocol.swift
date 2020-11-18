//
//  XLKLineDrawVerticalAxisScaleLineProtocol.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/7.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

protocol XLKLineDrawVerticalLineProtocol {
    
    /// 绘制垂直网格线
    /// - Parameters:
    ///   - context: 绘制板
    ///   - drawSize: 绘制区域
    ///   - contentInset: 绘制区域内边距
    ///   - lineCount: 网格线数量
    ///   - lineColor: 网格线颜色
    ///   - lineWidth: 网格线宽度
    func drawVerticalLines(context: CGContext,
                           drawSize: CGSize,
                           contentInset: UIEdgeInsets,
                           lineCount: Int,
                           lineColor: UIColor,
                           lineWidth: CGFloat)
}

extension XLKLineDrawVerticalLineProtocol {
    
    /// 实现绘制垂直网格线
    /// - Parameters:
    ///   - context: 绘制板
    ///   - drawSize: 绘制区域
    ///   - contentInset: 绘制区域内边距
    ///   - lineCount: 网格线数量
    ///   - lineColor: 网格线颜色
    ///   - lineWidth: 网格线宽度
    func drawVerticalLines(context: CGContext,
                           drawSize: CGSize,
                           contentInset: UIEdgeInsets,
                           lineCount: Int,
                           lineColor: UIColor,
                           lineWidth: CGFloat) {
        
        let spaceWidth = (drawSize.width - contentInset.left - contentInset.right) / CGFloat(lineCount + 1)
        let height = drawSize.height
        for index in 1 ... lineCount {
            
            let x = CGFloat(index) * spaceWidth
            let startPoint = CGPoint(x: x,
                                     y: contentInset.top)
            let endPoint = CGPoint(x: x,
                                   y: height - contentInset.bottom)
            let brushModel = XLKLine.LineBrush.Model(positions: [startPoint, endPoint],
                                                     lineColor: lineColor,
                                                     lineWidth: lineWidth)
            XLKLine.LineBrush.draw(context: context,
                                   model: brushModel)
        }
    }
}
