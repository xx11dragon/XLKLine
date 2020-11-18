//
//  XLKLine.Manager.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/5/6.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    open class Manager {
        
        /// 配置对象
        open var config: Config = Config()
        
        /// 获取数据
        open var models: [Model] = [] {
            
            didSet {
                
                generateIndicatorData(models: models,
                                      config: config)
                reloadCurrentLocation()
            }
        }
        
        /// 获取显示范围
        open var displayWidth: ((Manager)->(CGFloat))?
        
        /// 显示宽度
        open func getDisplayWidth() -> CGFloat {
            
            return displayWidth?(self) ?? 0
        }
        
        /// 当前左侧位置
        open var currentLocation: Int = 0
        
        // MARK: - Methods
        /// 显示模型
        /// - Parameter displayWidth: 显示宽度
        /// - Returns: 显示模型
        public func displayBarModels(displayWidth: CGFloat? = nil) -> [XLKLine.Model] {
            
            let width = displayWidth ?? getDisplayWidth()
            return Manager.displayBarModels(models: models,
                                            displayWidth: width,
                                            currentLocation: currentLocation,
                                            config: config)
        }
        
        /// 显示指标模型
        /// - Parameter displayWidth: 显示宽度
        /// - Returns: 显示模型
        public func displayIndicatorModels(displayWidth: CGFloat? = nil) -> XLKLine.Manager.DisplayModel {
            let width = displayWidth ?? getDisplayWidth()
            return Manager.displayIndicatorModels(models: models,
                                                  displayWidth: width,
                                                  currentLocation: currentLocation,
                                                  config: config)
        }
        
        
        /// 显示数据范围值
        /// - Parameter bounds: 显示范围
        /// - Returns: 范围值
        open func displayBarLimitValue(bounds: CGRect) -> LimitValue? {
            
            let type = config.candleStickIndicatorType
            let models = displayBarModels()
            return Manager.candleStickLimitValue(models: models,
                                                 indicatorType: type)
        }
        
        /// 蜡烛图绘制模型
        /// - Parameter bounds: 绘制范围
        /// - Returns: 绘制模型
        open func displayCandleStickBarModel(bounds: CGRect) -> [XLKLineCandleStickBarBrushProtocol] {
            
            let models = displayBarModels()
            guard let limitValue = displayBarLimitValue(bounds: bounds) else {
                return []
            }
            let contentInset = config.candleStickContentInset
            return XLKLine.CandleStickBarBrushModel.generate(models: models,
                                                             bounds: bounds,
                                                             contentInset: contentInset,
                                                             limitValue: limitValue,
                                                             config: config)
        }
        
        /// 获取蜡烛图一个模型
        /// - Parameters:
        ///   - bounds: 绘制范围
        ///   - index: 索引
        /// - Returns: 模型
        open func displayCandleStickBarModel(bounds: CGRect,
                                             at index: Int) -> XLKLineCandleStickBarBrushProtocol? {
            
            let models = displayCandleStickBarModel(bounds: bounds)
            if index < 0 || models.count <= index {
                return nil
            }
            return models[index]
        }
        
        /// 获取蜡烛图一个模型
        /// - Parameters:
        ///   - bounds: 绘制范围
        ///   - positionX: 模型显示位置
        /// - Returns: 模型
        open func displayCandleStickBarModel(bounds: CGRect,
                                             positionX: CGFloat) -> XLKLineCandleStickBarBrushProtocol? {
            
            guard let index = barIndex(positionX: positionX) else {
                return nil
            }
            return displayCandleStickBarModel(bounds: bounds, at: index)
        }

        open func displayCandleStickTimeLineModel(bounds: CGRect) -> CandleStickTimeline? {
            
            let display = displayIndicatorModels()
            guard let limitValue = Manager.closeLimitValue(models: display.models) else {
                return nil
            }
            return XLKLine.CandleStickTimeline.generate(models: display.models,
                                                        leadingPreloadModels: display.leadingPreloadModels,
                                                        trailingPreloadModels: display.trailingPreloadModels,
                                                        bounds: bounds,
                                                        limitValue: limitValue,
                                                        config: config)
        }
        
        /// 分时图单个数据坐标
        /// - Parameters:
        ///   - bounds: 绘制范围
        ///   - index: 显示位置
        /// - Returns: 坐标
        open func dispalyCandleStickTimeLineModelPosition(bounds: CGRect,
                                                          at index: Int) -> CGPoint? {
            let display = displayIndicatorModels()
            let index = index + display.leadingPreloadModels.count
            if index < 0 || models.count <= index {
                return nil
            }
            return displayCandleStickTimeLineModel(bounds: bounds)?.positions[index]
        }
        
        /// 分时图单个数据坐标
        /// - Parameters:
        ///   - bounds: 绘制范围
        ///   - positionX: 显示位置
        /// - Returns: 坐标
        open func dispalyCandleStickTimeLineModelPosition(bounds: CGRect,
                                                          positionX: CGFloat) -> CGPoint? {
            
            guard let index = barIndex(positionX: positionX) else {
                return nil
            }
            return dispalyCandleStickTimeLineModelPosition(bounds: bounds,
                                                           at: index)
        }
        
        /// 蜡烛图绘制指标模型
        /// - Parameter bounds: 绘制范围
        /// - Returns: 绘制指标模型
        open func displayCandleStickIndicatorModel(bounds: CGRect) -> [XLKLineLineBrushProtocol] {
            
            let type = config.candleStickIndicatorType
            let display = displayIndicatorModels()
            guard let limitValue = Manager.candleStickLimitValue(models: display.models,
                                                                 indicatorType: type) else {
                                                                    return []
            }
            switch type {
            case .MA:
                return XLKLine.CandleStickMA.generate(models: display.models,
                                                      leadingPreloadModels: display.leadingPreloadModels,
                                                      trailingPreloadModels: display.trailingPreloadModels,
                                                      bounds: bounds,
                                                      limitValue: limitValue,
                                                      config: config)
            case .BOLL:
                return XLKLine.CandleStickBOLL.generate(models: display.models,
                                                        leadingPreloadModels: display.leadingPreloadModels,
                                                        trailingPreloadModels: display.trailingPreloadModels,
                                                        bounds: bounds,
                                                        limitValue: limitValue,
                                                        config: config)
            default:
                return []
            }
        }
        
        open func displayVolumeBarModel(bounds: CGRect) -> [XLKLineLineBrushProtocol] {
            
            let type = config.candleStickIndicatorType
            let models = displayBarModels()
            guard let limitValue = Manager.volumeLimitValue(models: models,
                                                            indicatorType: type) else {
                                                                return []
            }
            return XLKLine.Volume.generate(models: models,
                                           bounds: bounds,
                                           limitValue: limitValue,
                                           config: config)
        }
        
        open func displayVolumeIndicatorModel(bounds: CGRect) -> [XLKLineLineBrushProtocol] {
            
            let type = config.candleStickIndicatorType
            let display = displayIndicatorModels()
            guard let limitValue = Manager.volumeLimitValue(models: display.models,
                                                            indicatorType: type) else {
                                                                return []
            }
            return XLKLine.VolumeMA.generate(models: display.models,
                                             leadingPreloadModels: display.leadingPreloadModels,
                                             trailingPreloadModels: display.trailingPreloadModels,
                                             bounds: bounds,
                                             limitValue: limitValue,
                                             config: config)
        }
        
        open func displayAccessoryMACD(bounds: CGRect) -> XLKLine.AccessoryMACD.Response? {
            
            let type = config.accessoryIndicatorType
            let display = displayIndicatorModels()
            guard let limitValue = Manager.accessoryLimitValue(models: display.models,
                                                               indicatorType: type) else {
                                                                return nil
            }
            return XLKLine.AccessoryMACD.generate(models: display.models,
                                                  leadingPreloadModels: display.leadingPreloadModels,
                                                  trailingPreloadModels: display.trailingPreloadModels,
                                                  bounds: bounds,
                                                  limitValue: limitValue,
                                                  config: config)
        }
        
        open func displayAccessoryKDJ(bounds: CGRect) -> XLKLine.AccessoryKDJ.Response? {
            
            let type = config.accessoryIndicatorType
            let display = displayIndicatorModels()
            guard let limitValue = Manager.accessoryLimitValue(models: display.models,
                                                               indicatorType: type) else {
                                                                return nil
            }
            
            return XLKLine.AccessoryKDJ.generate(models: display.models,
                                                 leadingPreloadModels: display.leadingPreloadModels,
                                                 trailingPreloadModels: display.trailingPreloadModels,
                                                 bounds: bounds,
                                                 limitValue: limitValue,
                                                 config: config)
        }
        
        open func displayAccessoryRSI(bounds: CGRect) -> [XLKLine.AccessoryRSI] {
            
            let type = config.accessoryIndicatorType
            let display = displayIndicatorModels()
            guard let limitValue = Manager.accessoryLimitValue(models: display.models,
                                                               indicatorType: type) else {
                                                                return []
            }
            return XLKLine.AccessoryRSI.generate(models: display.models,
                                                 leadingPreloadModels: display.leadingPreloadModels,
                                                 trailingPreloadModels: display.trailingPreloadModels,
                                                 bounds: bounds,
                                                 limitValue: limitValue,
                                                 config: config)
        }
        
        open func displayAccessoryWR(bounds: CGRect) -> [XLKLine.AccessoryWR] {
            
            let type = config.accessoryIndicatorType
            let display = displayIndicatorModels()
            guard let limitValue = Manager.accessoryLimitValue(models: display.models,
                                                               indicatorType: type) else {
                                                                return []
            }
            return XLKLine.AccessoryWR.generate(models: display.models,
                                                leadingPreloadModels: display.leadingPreloadModels,
                                                trailingPreloadModels: display.trailingPreloadModels,
                                                bounds: bounds,
                                                limitValue: limitValue,
                                                config: config)
        }
        
        /// 重置当前位置
        open func reloadCurrentLocation() {
            
            if models.isEmpty {
                
                currentLocation = 0
                return
            }
            currentLocation = Manager.defaultLocation(displayWidth: getDisplayWidth(),
                                                      modelsCount: models.count,
                                                      currentLocation: currentLocation,
                                                      config: config)
        }
        
        /// 更新当前位置
        open func updateCurrentLocation() {
            
            if models.isEmpty {
                
                currentLocation = 0
                return
            }
            let defualtLocation = Manager.defaultLocation(displayWidth: getDisplayWidth(),
                                                          modelsCount: models.count,
                                                          currentLocation: currentLocation,
                                                          config: config)
            currentLocation = min(defualtLocation, max(currentLocation, 0))
        }
        
        
        /// x坐标重叠数据的index
        /// - Parameter locationX: x坐标
        /// - Returns: 数据的index
        open func barIndex(positionX: CGFloat) -> Int? {
            
            let models = displayBarModels()
            guard !models.isEmpty else {
                return nil
            }
            let unitSpace = config.klineWidth + config.klineSpace
            return min(Int(positionX / unitSpace), models.count - 1)
        }
        
        /// x坐标重叠的数据
        /// - Parameter locationX: x坐标
        /// - Returns: 重叠的数据
        open func model(locationX: CGFloat) -> XLKLine.Model? {
            
            guard let index = barIndex(positionX: locationX) else {
                return nil
            }
            return displayBarModels()[index]
        }
        
        /// x坐标重叠的 bar.frame.x
        /// - Parameter locationX: x坐标
        /// - Returns: bar.frame.x
        open func barFrameX(locationX: CGFloat) -> CGFloat? {
            
            let unitSpace = config.klineWidth + config.klineSpace
            guard let index = barIndex(positionX: locationX) else {
                return nil
            }
            return CGFloat(index) * unitSpace + 1.5
        }
        
        // MARK: - Init
        public init() {
            
        }
    }
}
