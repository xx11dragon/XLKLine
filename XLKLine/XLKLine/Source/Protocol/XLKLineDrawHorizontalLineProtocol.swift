//
//  XLKLineDrawHorizontalAxisScaleLineProtocol.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/6/23.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

protocol XLKLineDrawHorizontalLineProtocol {
    
    /// 绘制水平网格线
    /// - Parameters:
    ///   - context: 绘制板
    ///   - drawSize: 绘制区域
    ///   - contentInset: 绘制区域内边距
    ///   - lineCount: 网格线数量
    ///   - lineColor: 网格线颜色
    ///   - lineWidth: 网格线宽度
    func drawHorizontalLines(context: CGContext,
                             drawSize: CGSize,
                             contentInset: UIEdgeInsets,
                             lineCount: Int,
                             lineColor: UIColor,
                             lineWidth: CGFloat)
}

extension XLKLineDrawHorizontalLineProtocol {
    
    /// 实现绘制水平网格线
    /// - Parameters:
    ///   - context: 绘制板
    ///   - drawSize: 绘制区域
    ///   - contentInset: 绘制区域内边距
    ///   - lineCount: 网格线数量
    ///   - lineColor: 网格线颜色
    ///   - lineWidth: 网格线宽度
    func drawHorizontalLines(context: CGContext,
                             drawSize: CGSize,
                             contentInset: UIEdgeInsets,
                             lineCount: Int,
                             lineColor: UIColor,
                             lineWidth: CGFloat) {
        
        let spaceHeight = (drawSize.height - contentInset.top - contentInset.bottom) / CGFloat(lineCount + 1)
        let width = drawSize.width
        for index in 0 ... lineCount {
            
            let x: CGFloat = 0
            let startPoint = CGPoint(x: x,
                                     y: CGFloat(index) * spaceHeight + contentInset.top)
            let endPoint = CGPoint(x: width,
                                   y: CGFloat(index) * spaceHeight + contentInset.top)
            let brushModel = XLKLine.LineBrush.Model(positions: [startPoint, endPoint],
                                                     lineColor: lineColor,
                                                     lineWidth: lineWidth)
            XLKLine.LineBrush.draw(context: context,
                                   model: brushModel)
        }
    }
}
