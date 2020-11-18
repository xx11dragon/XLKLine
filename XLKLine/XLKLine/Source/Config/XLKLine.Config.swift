//
//  XLKLine.Config.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/4/23.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine {
    
    public struct Config {
        
        /// 蜡烛图指标类型
        var candleStickIndicatorType: Model.IndicatorType = .MA
        
        /// 副视图指标类型
        var accessoryIndicatorType: Model.IndicatorType = .WR
        
        /// 时间戳类型
        var timestampType: TimestampType = .ms
        
        /// K线类型
        var timeLineType: TimeLineType = .timeline
        
        /// 显示数字小数点位数
        var decimalScale: Int = 2
        
        /// 背景颜色
        var backgroundColor: UIColor = Color(hex: 0x0D1926)
        
        /// 蜡烛图背景颜色
        var candleStickBackgroundColor: UIColor = Color(hex: 0x0D1926)
        
        /// 交易量图背景颜色
        var volumeBackgroundColor: UIColor = Color(hex: 0x0D1926)
        
        /// 副视图背景颜色
        var accessoryBackgroundColor: UIColor = Color(hex: 0x0D1926)
        
        /// 日期视图背景颜色
        var dateBackgroundColor: UIColor = Color(hex: 0x0D1926)
        
        /// 涨的颜色
        var increaseColor: UIColor = Color(hex: 0xFF5353)
        
        /// 跌的颜色
        var decreaseColor: UIColor = Color(hex: 0x00B07C)
        
        /// 长按指示条颜色
        var indicatorBarColor: UIColor = Color(hex: 0xFFFFFF).withAlphaComponent(0.3)
        
        /// 长按指示圆点颜色
        var indicatorDotColor: UIColor = Color(hex: 0xFFFFFF)
        
        /// 长按指示圆点半径
        var indicatorDotRadius: CGFloat = 2
        
        /// 量视图高度
        var volumeViewHeightScale: CGFloat = 0.12
        
        /// 副视图高度
        var accessoryViewHeightScale: CGFloat = 0.12
        
        /// 日期视图高度
        var dateViewHeight: CGFloat = 20
        
        /// k线的间隔
        var klineSpace: CGFloat = 1.5
        
        /// k线图主体宽度
        var klineWidth: CGFloat = 10
        
        /// 上下影线宽度
        var klineShadowLineWidth: CGFloat = 1.0
        
        /// k线最大宽度
        var klineMaxWidth: CGFloat = 20.0
        
        /// k线最小宽度
        var klineMinWidth: CGFloat = 2.0
        
        /// k线缩放界限
        var klineScale: CGFloat = 0.03
        
        /// k线缩放因子
        var klineScaleFactor: CGFloat = 0.08
        
        /// 蜡烛图指标线宽度
        var candleStickIndicatorLineWidth: CGFloat = 0.8
        
        /// 蜡烛图分时线宽度
        var candleStickTimelineWidth: CGFloat = 1.5
        
        /// 交易量指标线宽度
        var volumeIndicatorLineWidth: CGFloat = 0.8
        
        /// 副视图
        var accessoryIndicatorLineWidth: CGFloat = 0.8
        
        /// 蜡烛图内边距
        var candleStickContentInset: UIEdgeInsets = UIEdgeInsets(top: 40, left: 0, bottom: 5, right: 0)
        
        /// 交易量内边距
        var volumeContentInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        /// 副视图内边距
        var accessoryContentInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        /// 指标左侧预加载数量
        var indicatorLeadingPreloadCount: Int = 1
        
        /// 指标右侧预加载数量
        var indicatorTrailingPreloadCount: Int = 2
        
        /// 垂直网格线数量
        var verticalAxisScaleLineCount: Int = 4
        
        /// 蜡烛图水平网格线数量
        var horizontalCandleStickAxisScaleLineCount: Int = 4
        
        /// 蜡烛图水平数值大数点最小保留位数
        var candleStickAxisScaleMaxFractionDigits: Int = 2
        
        /// 蜡烛图水平数值小数点最小保留位数
        var candleStickAxisScaleMinFractionDigits: Int = 2
        
        /// 网格线宽度
        var axisScaleLineWidth: CGFloat = 0.8
        
        /// 网格线颜色
        var axisScaleLineColor: UIColor = Color(hex: 0x172A40)
        
        /// 蜡烛图水平刻度线数量
        var candleStickHorizontalAxisScaleLineCount: Int = 3
        
        /// 副视图水平刻度线数量
        var accessoryHorizontalAxisScaleLineCount: Int = 1
        
        /// 日期文案字体
        var dateTextFont = UIFont.systemFont(ofSize: 10)
        
        /// 日期文案颜色
        var dateTextColor = Color(hex: 0x768AA7)
        
        /// 分时线 日期格式
        var realTimeDateFormat = "HH:mm"
        
        /// 分钟 日期格式
        var minuteDateFormat = "MM-dd HH:mm"
        
        /// 天 日期格式
        var dayDateFormat = "yyyy-MM-dd"
        
        /// 周 日期格式
        var weekDateFormat = "yyyy-MM-dd"
        
        /// 周 日期格式
        var monthDateFormat = "yyyy-MM-dd"
        
        /// 详情界面时间文案
        var detailTimeText = "时间"
        
        /// 详情界面开文案
        var detailOpenText = "开"
        
        /// 详情界面高文案
        var detailHighText = "高"
        
        /// 详情界面低文案
        var detailLowText = "低"
        
        /// 详情界面收文案
        var detailCloseText = "收"
        
        /// 详情界面盈亏额文案
        var detailChangeText = "盈亏额"
        
        /// 详情界面盈亏比文案
        var detailChgText = "盈亏比"
        
        /// 详情界面成交量文案
        var detailVolumeText = "成交量"
        
        /// 详情界面显示信息类型
        var detailInfoTypes: [DetailView.InfoType] = [
            .time,
            .open,
            .high,
            .low,
            .close,
            .change,
            .chg,
            .volume
        ]
    
        /// 外观布局
        var viewStyles: [XLKLine.ViewStyle] = [.candleStick, .volume, .accessory, .date]
        
        // MARK: 指标参数
        /// 蜡烛图MA参数
        var candleStickMADays: [Int] = [5, 10]
        
        /// 蜡烛图BOLL指标N参数
        var candleStickBOLLN: Int = 20
        
        /// 蜡烛图BOLL指标P参数
        var candleStickBOLLP: Double = 2
        
        /// 成交量MA参数
        var volumeMADays: [Int] = [5, 10]
        
        /// 副视图 MACD S 参数
        var accessoryMACDS: Int = 12
        
        /// 副视图 MACD L 参数
        var accessoryMACDL: Int = 26
        
        /// 副视图 MACD M 参数
        var accessoryMACDM: Int = 9
        
        /// 副视图 KDJ N 参数 (天)
        var accessoryKDJN: Int = 9
        
        /// 副视图 KDJ 参数
        var accessoryKDJM1: Int = 3
        
        /// 副视图 KDJ 参数
        var accessoryKDJM2: Int = 3
        
        /// 副视图 RSI 参数
        var accessoryRSI: [Int] = [6, 12, 24]
        
        /// 副视图 WR 参数
        var accessoryWR: [Int] = [6, 10]
        
        /// 蜡烛图轴刻度字体
        var candleStickAxisScaleFont: UIFont = UIFont.systemFont(ofSize: 10)
        
        /// 蜡烛图轴刻度宽度
        var candleStickAxisScaleWidth: CGFloat = 120
        
        /// 蜡烛图轴刻度文字颜色
        var candleStickAxisScaleTextColor: UIColor = Color(hex: 0x768AA7)
        
        /// 蜡烛图分时线颜色
        var candleStickTimelineColor: UIColor = Color(hex: 0x236AAD)
        
        /// 蜡烛图分时线渐变顶部颜色
        var candleStickTimelineFillGradualTopColor: UIColor = Color(hex: 0x236AAD).withAlphaComponent(0.3)
        
        /// 蜡烛图分时线渐变底部颜色
        var candleStickTimelineFillGradualBottomColor: UIColor = .clear
        
        /// 蜡烛图MA5指标颜色
        var candleStickMA5Color: UIColor = Color(hex: 0x4498EA)
        
        /// 蜡烛图MA10指标颜色
        var candleStickMA10Color: UIColor = Color(hex: 0x00FFFF)
        
        /// 蜡烛图MA30指标颜色
        var candleStickMA30Color: UIColor = Color(hex: 0xFFFF00)
                
        /// 蜡烛图BOLL UP指标颜色
        var candleStickBOLLUpColor: UIColor = Color(hex: 0x00FFFF)
        
        /// 蜡烛图BOLL MB指标颜色
        var candleStickBOLLMbColor: UIColor = Color(hex: 0x4498EA)
        
        /// 蜡烛图BOLL DN指标颜色
        var candleStickBOLLDnColor: UIColor = Color(hex: 0xFFFF00)
        
        /// 交易量MA5指标颜色
        var volumeMA5Color: UIColor = Color(hex: 0x4498EA)
        
        /// 交易量MA10指标颜色
        var volumeMA10Color: UIColor = Color(hex: 0x00FFFF)
        
        /// 交易量EMA12指标颜色
        var volumeEMA12Color: UIColor = Color(hex: 0x4498EA)
        
        /// 交易量EMA26指标颜色
        var volumeEMA26Color: UIColor = Color(hex: 0x00FFFF)
        
        /// 副视图MACD指标颜色
        var accessoryMACDColor: UIColor = Color(hex: 0x00FFFF)
        
        /// 副视图MACD DIF 指标颜色
        var accessoryMACDDIFColor: UIColor = Color(hex: 0xC71585)
        
        /// 副视图MACD DEA 指标颜色
        var accessoryMACDDEAColor: UIColor = Color(hex: 0x1E90FF)
        
        /// KDJ K 指标颜色
        var accessoryKDJKColor: UIColor = Color(hex: 0x1E90FF)
        
        /// KDJ D 指标颜色
        var accessoryKDJDColor: UIColor = Color(hex: 0xFFA500)
        
        /// KDJ J 指标颜色
        var accessoryKDJJColor: UIColor = Color(hex: 0xFFD700)
        
        /// 副视图 RSI6 指标颜色
        var accessoryRSI6Color: UIColor = Color(hex: 0x1E90FF)
        
        /// 副视图 RSI12 指标颜色
        var accessoryRSI12Color: UIColor = Color(hex: 0xFFA500)
        
        /// 副视图 RSI24 指标颜色
        var accessoryRSI24Color: UIColor = Color(hex: 0xFFD700)
        
        /// 副视图 WR6 指标颜色
        var accessoryWR6Color: UIColor = Color(hex: 0x1E90FF)
        
        /// 副视图 WR12 指标颜色
        var accessoryWR12Color: UIColor = Color(hex: 0xFFA500)
        
        /// 副视图 WR24 指标颜色
        var accessoryWR24Color: UIColor = Color(hex: 0xFFD700)
        
        /// 指标0颜色
        var indicator0Color: UIColor = Color(hex: 0xFFA500)
        
        /// 指标1颜色
        var indicator1Color: UIColor = Color(hex: 0x1E90FF)
        
        /// 指标2颜色
        var indicator2Color: UIColor = Color(hex: 0xFFD700)
        
        /// 指标颜色
        /// - Parameters:
        ///   - type: 指标类型
        ///   - param: 指标参数
        /// - Returns: 颜色
        func indicatorColor(type: XLKLine.Model.IndicatorType,
                            index: Int? = nil) -> UIColor {

            if let index = index {
                switch index {
                case 0:
                    return indicator0Color
                case 1:
                    return indicator1Color
                case 2:
                    return indicator2Color
                default:
                    return Color(hex: 0xFFFFFF)
                }
            }

            switch type {
            
            case .BOLL_UP:
                return candleStickBOLLUpColor
            case .BOLL_MB:
                return candleStickBOLLMbColor
            case .BOLL_DN:
                return candleStickBOLLDnColor
            case .MACD:
                return accessoryMACDColor
            case .DIF:
                return accessoryMACDDIFColor
            case .DEA:
                return accessoryMACDDEAColor
            case .KDJ_K:
                return accessoryKDJKColor
            case .KDJ_D:
                return accessoryKDJDColor
            case .KDJ_J:
                return accessoryKDJJColor
            default:
                return Color(hex: 0xFFFFFF)
            }
        }
    }
}
