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

public extension UIImage {
    
    public enum Direction {
        case TopBottom
        case LeftRight
        case LeftTopRightBottom
        case LeftBottomRightTop
    }
    
    //创建纯色图片
    public static func creatWithColor(_ color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //创建过度色图片
    public static func creatWith(size:CGSize,startColor:UIColor, endColor:UIColor, direction:Direction) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        let context = UIGraphicsGetCurrentContext()
        context!.saveGState()
        let colorSpace = startColor.cgColor.colorSpace
        let cfArray = [startColor.cgColor,endColor.cgColor]
        let gradient = CGGradient(colorsSpace: colorSpace,colors: cfArray as CFArray,locations: nil)
        
        var startPoint:CGPoint!
        var endPoint:CGPoint!
        switch direction {
        case .LeftRight:
            startPoint = CGPoint(x: 0, y: size.height/2)
            endPoint = CGPoint(x: size.width, y: size.height/2)
        case .TopBottom:
            startPoint = CGPoint(x: size.width/2, y: 0)
            endPoint = CGPoint(x: size.width/2, y: size.height)
        case .LeftTopRightBottom:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: size.width, y: size.height)
        case .LeftBottomRightTop:
            startPoint = CGPoint(x: 0, y: size.height)
            endPoint = CGPoint(x: size.width, y: 0)
        }
        context!.drawLinearGradient(gradient!,start: startPoint,end: endPoint,options: [.drawsBeforeStartLocation,.drawsAfterEndLocation])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    
    //颜色渲染图片
    public func withColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context?.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //高斯模糊(模糊半径)
    public func gaussianfilter(radius: CGFloat) -> UIImage {
        //获取原始图片
        let originalImage = self
        let inputImage =  CIImage(image: originalImage)
        //使用高斯模糊滤镜
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey:kCIInputImageKey)
        //设置模糊半径值（越大越模糊）
        filter.setValue(radius, forKey: kCIInputRadiusKey)
        let outputCIImage = filter.outputImage!
        let rect = CGRect(origin: CGPoint.zero, size: originalImage.size)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(outputCIImage, from: rect)
        return UIImage(cgImage: cgImage!)
    }
    
    
    /// 截屏
    ///
    /// - Parameters:
    ///   - view: 要截屏的view
    /// - Returns: 一个UIImage
    public static func cutFullImageWithView(scrollView:UIScrollView) -> UIImage
    {
        // 记录当前的scrollView的偏移量和坐标
        let currentContentOffSet:CGPoint = scrollView.contentOffset
        let currentFrame:CGRect = scrollView.frame;
        
        // 设置为zero和相应的坐标
        scrollView.contentOffset = CGPoint.zero
        scrollView.frame = CGRect.init(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        
        // 参数①：截屏区域  参数②：是否透明  参数③：清晰度
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, true, UIScreen.main.scale)
        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // 重新设置原来的参数
        scrollView.contentOffset = currentContentOffSet
        scrollView.frame = currentFrame
        
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    /// 截屏
    ///
    /// - Parameters:
    ///   - view: 要截屏的view
    /// - Returns: 一个UIImage
    public static func cutImageWithView(view:UIView) -> UIImage
    {
        // 参数①：截屏区域  参数②：是否透明  参数③：清晰度
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return image;
    }
    
    public func resizeWithWidth(_ width: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))
        
        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    /// EZSE:
    public func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }
    
    /// EZSE:
    public func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }
}
