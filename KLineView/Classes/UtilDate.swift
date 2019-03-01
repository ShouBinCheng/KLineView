//
//  UtilDate.swift
//  KLineView
//
//  Created by 程守斌 on 2019/3/1.
//

import Foundation

public class UtilDate: NSObject {
    //格式化为自定义模式
    static public func toString(formatter:String, timeIntervalSince1970: Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(timeIntervalSince1970))
        let dformatter = DateFormatter()
        dformatter.dateFormat = formatter
        return dformatter.string(from:date)
    }
}
