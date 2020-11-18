//
//  XLKLineDateView.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/6.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    /// 日期视图
    class DateView: UIView {
        
        let manager: Manager
        
        open var dateLabels: [CATextLayer] = []
        
        private lazy var topLine: UIView = {
            var view = UIView()
            view.backgroundColor = manager.config.axisScaleLineColor
            addSubview(view)
            return view
        }()
        
        private func initDateLabels() {
            
            dateLabels.forEach { (label) in
                label.removeFromSuperlayer()
            }
            dateLabels.removeAll()
            let textFont = manager.config.dateTextFont
            let textColor = manager.config.dateTextColor
            for _ in 0 ..< manager.config.verticalAxisScaleLineCount + 2 {
                let textLayer = XLKLine.TextLayer(font: textFont,
                                                  textColor: textColor)
                textLayer.alignmentMode = .center
                textLayer.font = UIFont.systemFont(ofSize: 10)
                layer.addSublayer(textLayer)
                dateLabels.append(textLayer)
            }
        }
        
        open func reloadData() {

            if manager.currentLocation < 0 {
                return
            }
            let timestampType = manager.config.timestampType
            let dateFormat = manager.config.timeLineType.dateFormat(config: manager.config)
            let models = Array(manager.models[manager.currentLocation ..< manager.models.count])
            let unitSpace = manager.config.klineWidth + manager.config.klineSpace
            for (label) in dateLabels {
                
                label.string = ""
                let index = Int(label.position.x / unitSpace)
                if 0 <= index && index < models.count {
                    let displayDate = models[index].displayDate(format: dateFormat,
                                                                timestampType: timestampType)
                    label.string = displayDate
                }
            }
        }
        
        private func layoutTopLine() {
            
            topLine.frame = CGRect(x: 0,
                                   y: 0,
                                   width: bounds.width,
                                   height: manager.config.axisScaleLineWidth)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let width = bounds.width / CGFloat(manager.config.verticalAxisScaleLineCount + 1)
            for (index, label) in dateLabels.enumerated() {
                let x = CGFloat(index) * width - width / 2
                let height: CGFloat = label.fontSize
                let y: CGFloat = (bounds.height - height) / 2
                label.frame = CGRect(x: x,
                                     y: y,
                                     width: width,
                                     height: height)
            }
            backgroundColor = manager.config.dateBackgroundColor
            layoutTopLine()
        }
        
        // MARK: - Init
        public init(manager: XLKLine.Manager) {
            self.manager = manager
            super.init(frame: .zero)
            initDateLabels()
        }
        
        required public init?(coder: NSCoder) {
            
            fatalError("init(coder:) has not been implemented")
        }
    }
}
