//
//  BaseView.swift
//  KLineView
//
//  Created by 程守斌 on 2019/3/1.
//

import Foundation

open class BaseView: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        makeConstraint()
        makeEvent()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //创建UI 子类需override
    open func makeUI(){
    }
    
    //创建约束 子类需override
    open func makeConstraint(){
    }
    
    //创建事件 子类需override
    open func makeEvent() {
    }
    
    //刷新UI 子类需override
    open func refreshUI(viewModel:Any?){
    }
}
