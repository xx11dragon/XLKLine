//
//  XLKLine.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/6.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    /// 视图
    open class View: UIView {
        
        open var manager: Manager
        
        open var models: [Model] {
            
            return manager.models
        }
        
        /// 当前拖动手势位置
        private var panGesturePoint: CGPoint?
        
        /// 当前比例
        private var scale: CGFloat = 1.0
        
        /// 蜡烛图
        private lazy var candleStickView: XLKLine.CandleStickView = {
            var view = XLKLine.CandleStickView(manager: manager)
            addSubview(view)
            return view
        }()
        
        /// 交易量图
        private lazy var volumeView: XLKLine.VolumeView = {
            var view = XLKLine.VolumeView(manager: manager)
            addSubview(view)
            return view
        }()
        
        /// 副视图
        private lazy var accessoryView: XLKLine.AccessoryView = {
            var view = XLKLine.AccessoryView(manager: manager)
            addSubview(view)
            return view
        }()
        
        /// 日期图
        private lazy var dateView: XLKLine.DateView = {
            var view = XLKLine.DateView(manager: manager)
            addSubview(view)
            return view
        }()
        
        /// 详情图
        private lazy var detailView: XLKLine.DetailView = {
            var view = XLKLine.DetailView(manager: manager)
            view.indicatorDotPosition = { [weak self] (position) in
            
                return self?.candleStickView.displayFocalPosition(at: position.x)
            }
            view.isHidden = true
            addSubview(view)
            return view
        }()

        // MARK: - Method
        /// 约束视图
        func constraintViews() {
            
            let volumeViewHeight = bounds.size.height * manager.config.volumeViewHeightScale
            let accessoryViewHeight = bounds.size.height * manager.config.accessoryViewHeightScale
            let dateViewHeight = manager.config.dateViewHeight
            
            func _candleStickViewHeight() -> CGFloat {
                
                var offset: CGFloat = 0
                manager.config.viewStyles.forEach { (style) in
                    
                    switch style {
                    case .date:
                        offset += dateViewHeight
                    case .accessory:
                        offset += accessoryViewHeight
                    case .volume:
                        offset += volumeViewHeight
                    case .candleStick:
                        break
                    }
                }
                return bounds.size.height - offset
            }
            /// invisible views
            [candleStickView, volumeView, accessoryView, dateView].forEach { (view) in
                view.isHidden = true
                view.frame = .zero
            }
            
            /// constraint views
            var previous: UIView?
            manager.config.viewStyles.forEach { (style) in
                
                let x: CGFloat = 0
                let y: CGFloat = previous == nil ? 0 : previous!.frame.maxY
                switch style {
                case .candleStick:
                    candleStickView.frame = CGRect(x: x,
                                                   y: y,
                                                   width: bounds.width,
                                                   height: _candleStickViewHeight())
                    candleStickView.isHidden = false
                    previous = candleStickView
                case .volume:
                    volumeView.frame = CGRect(x: x,
                                              y: y,
                                              width: bounds.width,
                                              height: volumeViewHeight)
                    volumeView.isHidden = false
                    previous = volumeView
                case .accessory:
                    accessoryView.frame = CGRect(x: x,
                                                 y: y,
                                                 width: bounds.width,
                                                 height: accessoryViewHeight)
                    accessoryView.isHidden = false
                    previous = accessoryView
                case .date:
                    dateView.frame = CGRect(x: x,
                                            y: y,
                                            width: bounds.width,
                                            height: dateViewHeight)
                    dateView.isHidden = false
                    previous = dateView
                }
            }
            detailView.frame = bounds
        }
        
        open func addGestures() {
            
            // 移动手势
            let panGesture = UIPanGestureRecognizer(target: self,
                                                    action: #selector(panGestureAction))
            panGesture.delegate = self
            addGestureRecognizer(panGesture)
            
            // 捏合手势
            let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                        action: #selector(pinchAction))
            addGestureRecognizer(pinchGesture)
            
            // 点击手势
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(tapGestureAction))
            addGestureRecognizer(tapGesture)
            
            // 长按手势
            let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                                action: #selector(longPressAction))
            addGestureRecognizer(longPressGesture)
        }
        
        open func reloadData() {
            
            manager.updateCurrentLocation()
            candleStickView.reloadData()
            volumeView.reloadData()
            accessoryView.reloadData()
            dateView.reloadData()
            detailView.reloadData()
        }
        
        /// 配置Manager对象
        private func setupManager() {
            
            manager.displayWidth = { [weak self] (_) in
                
                return self?.bounds.width ?? 0
            }
        }
        
        // MARK: - Override
        open override func layoutSubviews() {
            super.layoutSubviews()
            
            constraintViews()
        }
        
        // MARK: - Init
        public init(manager: XLKLine.Manager = Manager()) {
            self.manager = manager
            super.init(frame: .zero)
            
            setupManager()
            addGestures()
        }
        
        required public init?(coder: NSCoder) {
            
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - 手势
extension XLKLine.View: UIGestureRecognizerDelegate {
    
    @objc private func panGestureAction(recognizer: UIPanGestureRecognizer) {
        
        let location = recognizer.location(in: recognizer.view)
        switch recognizer.state {
            
        case .began:
            
            panGesturePoint = location
        case .changed:
            
            let klineUnit = manager.config.klineWidth + manager.config.klineSpace
            guard let panGesturePointX = panGesturePoint?.x,
                abs(location.x - panGesturePointX) >= klineUnit else {
                    return
            }
            let offsetIndex = Int((location.x - panGesturePointX) / klineUnit)
            manager.currentLocation -= offsetIndex
            reloadData()
            panGesturePoint = location
        case .ended:
            panGesturePoint = nil
        default:
            break
        }
    }
    
    @objc private func pinchAction(recognizer: UIPinchGestureRecognizer) {
        
        let different = recognizer.scale - scale
        let config = manager.config
        guard abs(different) > manager.config.klineScale else {
            
            return
        }
        let newKLineScale = different > 0 ? 1 + config.klineScaleFactor : 1 - config.klineScaleFactor
        let newKLineWidth = config.klineWidth * newKLineScale
        guard config.klineMinWidth <= newKLineWidth && newKLineWidth <= config.klineMaxWidth else {
            
            return
        }
        manager.config.klineWidth = newKLineWidth
        scale = recognizer.scale
        reloadData()
    }
    
    @objc private func tapGestureAction(recognizer: UIPanGestureRecognizer) {
        
        detailView.longPressPosition = nil
        detailView.reloadData()
    }

    // MARK: 长按手势
    @objc fileprivate func longPressAction(_ recognizer: UILongPressGestureRecognizer) {
        
        if recognizer.state == .began || recognizer.state == .changed {
            
            let position: CGPoint = recognizer.location(in: recognizer.view)
            detailView.longPressPosition = position
            detailView.reloadData()
        }
    }
}
