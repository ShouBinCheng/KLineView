//
//  Extension.swift
//  KLineView
//
//  Created by 程守斌 on 2019/3/1.
//

import Foundation
import UIKit

public extension Double {
    public func toString2f() -> String{
        return String(format: "%.2f",  self)
    }
    public func toString(pointCount:Int = 2) -> String{
        return String(format: "%.\(pointCount)f",  self)
    }
    
    /// 保留最长显示位数
    public func toString(maxLongCount:Int) -> String{
        let tmpCount = maxLongCount-1
        for count in stride(from: tmpCount, through: 0, by: -1) {
            if Decimal(self) >= pow(10, count) {
                return self.toString(pointCount: tmpCount-count)
            }
        }
        return self.toString(pointCount: tmpCount)
    }
}

public extension UIColor {
    
    public convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            self.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        }
    }
}

public extension UILabel {
    
    //便利构建器
    static public func create(text:String?, font:UIFont?, color:UIColor?) -> UILabel {
        let label = UILabel()
        if let text = text {
            label.text = text
        }
        if let font = font {
            label.font = font
        }
        if let color = color {
            label.textColor = color
        }
        return label
    }
    
    //获取文本宽度，text已经有值时使用
    public func widthForAuto() -> CGFloat {
        let label = UILabel.create(text: self.text, font: self.font, color: self.textColor)
        label.sizeToFit()
        return label.frame.size.width
    }
    
    //获取文本高度,设定宽度时使用
    public func heightWith(width:CGFloat) -> CGFloat {
        let label = UILabel.create(text: self.text, font: self.font, color: self.textColor)
        label.attributedText = self.attributedText
        label.frame.size.width = width
        label.sizeToFit()
        return label.frame.size.height
    }
}

public extension NSObject {
    public var className: String {
        return type(of: self).className
    }
    
    public static var className: String {
        return String(describing: self)
    }
}

public extension UIView {
    //添加多个View
    public func addSubviews(_ views:[UIView]){
        for view in views {
            self.addSubview(view)
        }
    }
}

public extension UITableView {
    //创建tableview
    static public func create(frame:CGRect, style:UITableView.Style, edgeTop:CGFloat, edgeBottom:CGFloat) -> UITableView {
        let tableView = UITableView.init(frame: frame, style: style)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        tableView.contentInset = UIEdgeInsets(top: edgeTop, left: 0, bottom: edgeBottom, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: edgeTop, left: 0, bottom: edgeBottom, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }
}
