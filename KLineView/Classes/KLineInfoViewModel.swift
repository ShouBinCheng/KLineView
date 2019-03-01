//
//  KLineInfoViewModel.swift
//  KLineView
//
//  Created by 程守斌 on 2019/3/1.
//

import Foundation
import Charts

public class KLineInfoViewModel: NSObject {
    var highlight:Highlight?
    var kLineModel:KLineModel?
    var kType:KType?
    var kIndexTop:KIndexTop?
    var kIndexBottom:KIndexBottom?
    var topHighly:Double?
    var bottomHighly:Double?
}
