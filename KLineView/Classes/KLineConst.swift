//
//  KLineConst.swift
//  KLineView
//
//  Created by 程守斌 on 2019/3/1.
//

import Foundation

public class KLineConst: NSObject {
    /// 背景色
    public static let kLineBgColor = UIColor(hexString: "#181C26")
    
    /// k线加载数据量
    public static let kLoadingLimit:Int    = 720
    
    /// 显示蜡烛的默认最大最少条数
    public static let showDefaultCount:Int = 80
    public static let showMinCount:Int     = 10
    public static let showMaxCount:Int     = 150
    
    /// 蜡烛图颜色
    public static let kCandleRedColor   = UIColor(hexString: "#F2334F")
    public static let kCandleGreenColor = UIColor(hexString: "#45B854")
    
    /// 分时线颜色
    public static let kTimeLineColor = UIColor(hexString: "#567AF2")
    
    /// 分时均线线颜色
    public static let kTimeLineAveLineColor = UIColor(hexString: "#53E7F2")
    
    /// SMA指标线天数
    public static let kSMALine1Days = 7
    public static let kSMALine2Days = 25
    //  SMA指标线颜色
    public static let kSMALine1Color = UIColor(hexString: "#54AFFF")
    public static let kSMALine2Color = UIColor(hexString: "#FF904C")
    
    
    /// EMA指标线天数
    public static let kEMALine1Days = 7
    public static let kEMALine2Days = 25
    // EMA指标线颜色
    public static let kEMALine1Color = UIColor(hexString: "#54AFFF")
    public static let kEMALine2Color = UIColor(hexString: "#FF904C")
    
    
    /// BOLL指标天数、k值、线颜色
    public static let kBOLLDayCount  = 20
    public static let kBOLL_KValue   = 2
    public static let kBOLLLineColor = UIColor(hexString: "#7BA5A6")
    
    
    /// MACD指标
    public static let kMACD_P1 = 12
    public static let kMACD_P2 = 26
    public static let kMACD_P3 = 9
    public static let kMACDDifLineColor = UIColor(hexString: "#B99E51")
    public static let kMACDDeaLineColor = UIColor(hexString: "#7BA5A6")
    
    /// KDJ指标
    public static let kKDJ_P1 = 9
    public static let kKDJ_P2 = 3
    public static let kKDJ_p3 = 3
    public static let kKDJKLineColor = UIColor(hexString: "#B99E51")
    public static let kKDJDLineColor = UIColor(hexString: "#81D6D9")
    public static let kKDJJLineColor = UIColor(hexString: "#725839")
    
    /// RSI指标
    public static let kRSILine1DayCount = 6
    public static let kRSILine2DayCount = 12
    public static let kRSILine3DayCount = 24
    public static let kRSILine1Color = UIColor(hexString: "#7CFFFB")
    public static let kRSILine2Color = UIColor(hexString: "#FF99EA")
    public static let kRSILine3Color = UIColor(hexString: "#DDFF68")
    
    /// KLineInfoView
    public static let kInfoLineColor = UIColor(hexString: "#5E6163")
    
    /// 深度图买盘线颜色
    public static let kLineDepthBuyLineColor = UIColor(hexString: "#45B854")
    /// 深度图卖盘线颜色
    public static let kLineDepthSellLineColor = UIColor(hexString: "#F2334F")
}

public class DefaultConst: NSObject {
    
    //屏幕宽高
    public static let kScreenWidth:CGFloat = UIScreen.main.bounds.size.width
    public static let kScreenHeight:CGFloat = UIScreen.main.bounds.size.height
    //一个像素宽度
    public static let kPixelSize:CGFloat = (1.0/UIScreen.main.scale)
}
