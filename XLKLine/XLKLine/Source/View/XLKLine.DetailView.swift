//
//  XLKLine.BarDetailView.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/6/24.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    class DetailView: UIView {
        
        public let manager: Manager
        
        open var longPressPosition: CGPoint?
        
        /// 获取指示点位置
        open var indicatorDotPosition: ((CGPoint)->(CGPoint?))?
        
        /// 获取指示数据
        open var indicatorModel: ((CGPoint)->(XLKLine.Model?))?
        
        /// 指示点
        private lazy var indicatorDotLayer: CALayer = {
            
            let radius = manager.config.indicatorDotRadius
            var dotlayer = CALayer()
            dotlayer.backgroundColor = manager.config.indicatorDotColor.cgColor
            dotlayer.bounds = CGRect(origin: .zero,
                                     size: CGSize(width: radius * 2, height: radius * 2))
            dotlayer.cornerRadius = radius
            dotlayer.masksToBounds = true
            layer.addSublayer(dotlayer)
            return dotlayer
        }()
        
        /// 指示条
        private lazy var indicatorBarLayer: CAGradientLayer = {
            
            var gradientLayer = CAGradientLayer()
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.colors = [
                manager.config.indicatorBarColor.withAlphaComponent(0.01).cgColor,
                manager.config.indicatorBarColor.cgColor,
                manager.config.indicatorBarColor.withAlphaComponent(0.01).cgColor
            ]
//            gradientLayer.locations = [0,0.25,1]
            layer.addSublayer(gradientLayer)
            return gradientLayer
        }()
        
        open func reloadData() {

            isHidden = longPressPosition == nil
            reloadIndicatorDot()
            reloadIndicatorBar()
            
        }
        
        open func reloadDetailView() {
            
            guard let longPressPosition = longPressPosition,
                let model = indicatorModel?(longPressPosition) else {
            
                return
            }
            print(model)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            reloadData()
        }
        
        open func reloadIndicatorDot() {
            
            guard let longPressPosition = longPressPosition,
                let position = indicatorDotPosition?(longPressPosition) else {
                
                indicatorDotLayer.isHidden = true
                return
            }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            indicatorDotLayer.position = position
            indicatorDotLayer.isHidden = false
            CATransaction.commit()
        }
        
        open func reloadIndicatorBar() {
            
            guard let longPressPosition = longPressPosition,
                let x = manager.barFrameX(locationX: longPressPosition.x) else {

                return
            }
            let y: CGFloat = 0
            let width = manager.config.klineWidth
            let height = bounds.size.height
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            indicatorBarLayer.frame = CGRect(x: x,
                                       y: y,
                                       width: width,
                                       height: height)
            CATransaction.commit()
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
