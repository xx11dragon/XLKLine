//
//  XLKLine.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/6.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    /// 主视图
    class CandleStickView: UIView {
        
        let manager: Manager
        
        /// 轴刻度
        var axisScaleLayers: [CATextLayer] = []
        
        /// 绘制网格
        open func drawAxisScaleLines() {
            
            drawVerticalLines()
        }
        
        /// 重置
        open func reloadData() {
            
            setNeedsDisplay()
        }
        
        // MARK: - Override
        public override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            layer.sublayers = nil
            drawAxisScaleLines()
            drawHorizontalAxisScaleLines()
            drawAxisScaleLayers()
            drawCandleStickData()
            drawIndicator()
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            backgroundColor = manager.config.candleStickBackgroundColor
        }
        
        // MARK: - Init
        public init(manager: XLKLine.Manager) {
            self.manager = manager
            super.init(frame: .zero)
        }
        
        required public init?(coder: NSCoder) {
            
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - 绘制数据
extension XLKLine.CandleStickView {
    
    open func drawCandleStickData() {
        
        switch manager.config.timeLineType {
        case .timeline:
            drawTimeline()
        default:
            drawCandleStickBars()
        }
    }
    
    /// 绘制蜡烛图
    open func drawCandleStickBars() {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let models = manager.displayCandleStickBarModel(bounds: bounds)
        XLKLine.CandleStickBarBrush.draw(context: context,
                                         models: models)
    }
    
    /// 绘制分时图
    open func drawTimeline() {
        
        guard let model = manager.displayCandleStickTimeLineModel(bounds: bounds) else {
            return
        }
        let realTimeLayer = XLKLine.CandleStickTimelineBrush.draw(bounds: bounds,
                                                                  model: model)
        layer.addSublayer(realTimeLayer)
    }
    
    
    open func drawIndicator() {
        
        guard manager.config.timeLineType != .timeline else {
            return
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let indicatorModels = manager.displayCandleStickIndicatorModel(bounds: bounds)
        for model in indicatorModels {
            XLKLine.LineBrush.draw(context: context,
                                   model: model)
        }
    }
}

// MARK: - 绘制网格
extension XLKLine.CandleStickView: XLKLineDrawVerticalLineProtocol, XLKLineDrawHorizontalLineProtocol {
    
    /// 绘制垂直网格
    open func drawVerticalLines() {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        drawVerticalLines(context: context,
                          drawSize: bounds.size,
                          contentInset: .zero,
                          lineCount: manager.config.verticalAxisScaleLineCount,
                          lineColor: manager.config.axisScaleLineColor,
                          lineWidth: manager.config.axisScaleLineWidth)
    }
    
    /// 绘制水平网格
    open func drawHorizontalAxisScaleLines() {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        drawHorizontalLines(context: context,
                            drawSize: bounds.size,
                            contentInset: manager.config.candleStickContentInset,
                            lineCount: manager.config.candleStickHorizontalAxisScaleLineCount,
                            lineColor: manager.config.axisScaleLineColor,
                            lineWidth: manager.config.axisScaleLineWidth)
    }
}

// MARK: - 轴刻度
extension XLKLine.CandleStickView {
    
    /// 初始化轴刻度文案控件
    /// - Returns: 轴刻度文案控件
    open func initAxisScaleLayer() -> CATextLayer {
        
        let textLayer = XLKLine.TextLayer(font: manager.config.candleStickAxisScaleFont,
                                          textColor: manager.config.candleStickAxisScaleTextColor)
        textLayer.alignmentMode = .right
        return textLayer
    }
    
    /// 删除所有轴刻度
    open func removeAxisScaleLayers() {
        
        axisScaleLayers.forEach {
            $0.removeFromSuperlayer()
        }
        axisScaleLayers.removeAll()
    }
    
    /// 绘制轴刻度
    open func drawAxisScaleLayers() {
        
        guard let limitValue = manager.displayBarLimitValue(bounds: bounds) else {
            
            return
        }
        
        removeAxisScaleLayers()
        let config = manager.config
        let contentInset = config.candleStickContentInset
        let lineCount = manager.config.horizontalCandleStickAxisScaleLineCount
        let width = manager.config.candleStickAxisScaleWidth
        let x = bounds.width - width - 5
        let height = manager.config.candleStickAxisScaleFont.pointSize
        let spaceHeight = (bounds.height - contentInset.top - contentInset.bottom) / CGFloat(lineCount)
        let textLayerCount = lineCount + 1
        let differentValue = limitValue.max - limitValue.min
        let unitValue = differentValue / Double(lineCount)
        
        for index in 0 ..< textLayerCount {
            
            let textLayer = initAxisScaleLayer()
            let frame: CGRect
            if index == 0 {
                let y = contentInset.top
                frame = CGRect(x: x, y: y, width: width, height: height)
            } else {
                let bottomOffset = index < textLayerCount - 1 ? contentInset.bottom : 0
                let y = CGFloat(index) * spaceHeight + contentInset.top - height - bottomOffset
                frame = CGRect(x: x, y: y, width: width, height: height)
            }
            let number = limitValue.min + unitValue * Double(textLayerCount - index - 1)
            textLayer.frame = frame
            textLayer.string = XLKLine.display(number: number,
                                               minimumFractionDigits: config.candleStickAxisScaleMinFractionDigits,
                                               maximumFractionDigits: config.candleStickAxisScaleMaxFractionDigits)
            layer.addSublayer(textLayer)
        }
    }
}

// MARK: - 根据用户点击的位置获取绘制点的位置
extension XLKLine.CandleStickView {
    
    /// 显示的焦点位置
    /// - Parameter positionX: 横坐标
    /// - Returns: 焦点位置
    func displayFocalPosition(at positionX: CGFloat) -> CGPoint? {
        
        switch manager.config.timeLineType {
        case .timeline:
            
            return manager.dispalyCandleStickTimeLineModelPosition(bounds: bounds,
                                                                   positionX: positionX)
        default:
            guard let model = manager.displayCandleStickBarModel(bounds: bounds,
                                                                 positionX: positionX),
                let position = model.body.positions.last else {
                    return nil
            }
            return position
        }
    }
}

