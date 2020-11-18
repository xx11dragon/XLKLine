//
//  XLKLine.Config.Theme.swift
//  XLKLine
//
//  Created by xx11dragon on 2020/4/23.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

extension XLKLine.Config {
    
    struct Theme {
        
        /// 背景颜色
        var backgroundColor: UIColor = XLKLine.Color(hex: 0x24262F)
        
        /// 涨的颜色
        var increaseColor: UIColor = XLKLine.Color(hex: 0xFF5353)
        
        /// 跌的颜色
        var decreaseColor: UIColor = XLKLine.Color(hex: 0x00B07C)
        
        /// 量视图高度
        var volumeViewHeightScale: CGFloat = 0.2
        
        /// 副视图高度
        var accessoryViewHeightScale: CGFloat = 0.2
        
        /// 日期视图高度
        var dateViewHeight: CGFloat = 10

        /// k线的间隔
        var klineSpace: CGFloat = 1.0
        
        /// k线图主体宽度
        var klineWidth: CGFloat = 8.0
        
        /// 上下影线宽度
        var klineShadowLineWidth: CGFloat = 1.0
        
        /// k线最大宽度
        var klineMaxWidth: CGFloat = 20.0
        
        /// k线最小宽度
        var klineMinWidth: CGFloat = 2.0
        
        /// k线缩放界限
        var klineScale: CGFloat = 0.03
        
        /// k线缩放因子
        var klineScaleFactor: CGFloat = 0.03
    }
}
