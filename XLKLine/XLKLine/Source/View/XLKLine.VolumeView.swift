//
//  XLKLine.XLKLine.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/6.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    /// 交易量视图
    class VolumeView: UIView {
        
        let manager: Manager
        
        /// 绘制网格
        func drawAxisScaleLines() {
            
            drawVerticalLines()
        }
        
        /// 重置
        open func reloadData() {
            
            setNeedsDisplay()
        }
        
        // MARK: - Override
        public override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            drawAxisScaleLines()
            drawVolumeBars()
            drawVolumeIndicator()
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            backgroundColor = manager.config.volumeBackgroundColor
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

// MARK: - 绘制网格
extension XLKLine.VolumeView: XLKLineDrawVerticalLineProtocol {
    
    /// 绘制垂直网格
    func drawVerticalLines() {
        
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
    
    /// 绘制交易量
    func drawVolumeBars() {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let models = manager.displayVolumeBarModel(bounds: bounds)
        for model in models {
            XLKLine.LineBrush.draw(context: context,
                                   model: model)
        }
    }
    
    /// 绘制交易量指标
    open func drawVolumeIndicator() {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let indicatorModels = manager.displayVolumeIndicatorModel(bounds: bounds)
        for model in indicatorModels {
            XLKLine.LineBrush.draw(context: context,
                                   model: model)
        }
    }
}
