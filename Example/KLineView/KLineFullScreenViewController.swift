//
//  KLineFullScreenViewController.swift
//  KLineView_Example
//
//  Created by 程守斌 on 2019/3/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import KLineView

class KLineFullScreenViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // k线数据
    private lazy var kLineDataSource:[KLineModel] = {
        var kLineDataSource = [KLineModel]()
        guard let jsonData = UtilSampleData.getKLineForDay() else {
            return kLineDataSource
        }
        let sampleData = KLineSampleDataResponse(JSON: jsonData)
        guard let models = sampleData?.chartlist else {
            return kLineDataSource
        }
        for item in models {
            let model = KLineModel(timestamp: 0, open: item.open!, high: item.high!, low: item.low!, close: item.close!, volume: item.volume!);
            kLineDataSource.append(model);
        }
        UtilAlgorithm.calculationResults(models: kLineDataSource)
        return kLineDataSource
    }()
    
    /// k线周期
    private lazy var kPeriod:KLinePeriod = {
        let kPeriod = KLinePeriod.getDefaultKLinePeriod()
        return kPeriod
    }()
    
    /// 上图指标
    private var kIndexTop:KIndexTop = .SMA
    /// 下图指标
    private var kIndexBottom:KIndexBottom = .VOL
    
    /// 顶部信息
    private lazy var topInfoView:KLineFullScreenTopInfoView = {
        let topInfoView = KLineFullScreenTopInfoView()
        topInfoView.backgroundColor = UIColor(hexString: "#1F232D")
        return topInfoView
    }()
    
    //k线图
    private lazy var kLineView:KLineView = {
        let kLineView = KLineView()
        kLineView.delegate = self
        return kLineView
    }()
    
    /// 指标视图
    private lazy var kIndexView:KLineFullScreenIndexView = {
        let kIndexView = KLineFullScreenIndexView()
        kIndexView.backgroundColor = UIColor(hexString: "#141821")
        kIndexView.refreshUI(topIndex: kIndexTop, bottomIndex: kIndexBottom)
        return kIndexView
    }()
    
    /// 底部视图
    private lazy var bottomView:KLineFullScreenBottomView = {
        let bottomView = KLineFullScreenBottomView()
        bottomView.backgroundColor = UIColor(hexString: "#1F232D")
        bottomView.refreshUI(kPeriod: kPeriod)
        return bottomView
    }()
    
    /// 选择图层
    private lazy var kCheckedView:KLineFullScreenCheckedView = {
        let kCheckedView = KLineFullScreenCheckedView()
        kCheckedView.isHidden = true
        return kCheckedView
    }()
}

//MARK: - life cycle
extension KLineFullScreenViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = KLineConst.kLineBgColor
        let transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
        self.view.layer.setAffineTransform(transform)
        
        makeUI()
        makeEvent()
        makeConstraint()
        refreshUI()
        self.kLineView.reloadData()
    }
}

//MARK: - private
extension KLineFullScreenViewController {
    
    private func makeUI() {
        self.view.addSubviews([topInfoView,kLineView,kIndexView
            ,bottomView,kCheckedView])
    }
    
    private func makeEvent() {
        // 关闭
        let _ = topInfoView.closeButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.dismiss(animated: true, completion: nil)
        })
        
        // 分时
        let _ = bottomView.timeLineButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.kPeriod = .periodTimeLine
            self.bottomView.refreshUI(kPeriod: self.kPeriod)
            self.refreshUI()
            self.request()
        })
        
        // 日线
        let _ = bottomView.dayLineButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.kPeriod = .periodDay
            self.bottomView.refreshUI(kPeriod: self.kPeriod)
            self.refreshUI()
            self.request()
        })
        
        // 周线
        let _ = bottomView.weekLineButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.kPeriod = .periodWeek
            self.bottomView.refreshUI(kPeriod: self.kPeriod)
            self.refreshUI()
            self.request()
        })
        
        // 小时
        let _ = bottomView.hourLineButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.kCheckedView.isHidden = false
            self.kCheckedView.refreshUI(isHour: true, kPeriod: self.kPeriod)
        })
        
        // 分钟
        let _ = bottomView.minuteLineButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.kCheckedView.isHidden = false
            self.kCheckedView.refreshUI(isHour: false, kPeriod: self.kPeriod)
        })
        
        //小时按钮
        for button in kCheckedView.hourButtons {
            let _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                let index = self.kCheckedView.hourButtons.index(of: button)
                switch index {
                case 0?:
                    self.kPeriod = .periodHour_1
                case 1?:
                    self.kPeriod = .periodHour_2
                case 2?:
                    self.kPeriod = .periodHour_4
                case 3?:
                    self.kPeriod = .periodHour_6
                case 4?:
                    self.kPeriod = .periodHour_12
                default:
                    break
                }
                self.bottomView.refreshUI(kPeriod: self.kPeriod)
                self.kCheckedView.isHidden = true
                self.refreshUI()
                self.request()
            })
        }
        
        //分钟按钮
        for button in kCheckedView.minuteButtons {
            let _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                let index = self.kCheckedView.minuteButtons.index(of: button)
                switch index {
                case 0?:
                    self.kPeriod = .periodMinute_1
                case 1?:
                    self.kPeriod = .periodMinute_5
                case 2?:
                    self.kPeriod = .periodMinute_15
                case 3?:
                    self.kPeriod = .periodMinute_30
                default:
                    break
                    
                }
                self.bottomView.refreshUI(kPeriod: self.kPeriod)
                self.kCheckedView.isHidden = true
                self.refreshUI()
                self.request()
            })
        }
        
        //指标按钮
        for button in kIndexView.indexButtons {
            let _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                let index = self.kIndexView.indexButtons.index(of: button)
                switch index {
                case 0?:
                    self.kIndexTop = .SMA
                case 1?:
                    self.kIndexTop = .EMA
                case 2?:
                    self.kIndexTop = .BOLL
                case 3?:
                    self.kIndexBottom = .VOL
                case 4?:
                    self.kIndexBottom = .MACD
                case 5?:
                    self.kIndexBottom = .KDJ
                case 6?:
                    self.kIndexBottom = .RSI
                default:
                    break
                }
                self.kLineView.setKIndexTop(index: self.kIndexTop)
                self.kLineView.setKIndexBottom(index: self.kIndexBottom)
                self.kIndexView.refreshUI(topIndex: self.kIndexTop, bottomIndex: self.kIndexBottom)
            })
        }
    }
    
    private func makeConstraint() {
        topInfoView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.left.right.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.bottom.right.equalToSuperview()
        }
        
        kLineView.snp.makeConstraints { (make) in
            make.left.equalTo(DefaultConst.kScreenHeight == 812 ? 30 : 0)
            make.right.equalTo(kIndexView.snp.left).offset(-5)
            make.top.equalTo(topInfoView.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top).offset(-5)
        }
        
        kIndexView.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.width.equalTo(DefaultConst.kScreenHeight == 812 ? 80 : 50)
            make.top.equalTo(topInfoView.snp.bottom).offset(5)
            make.bottom.equalTo(bottomView.snp.top).offset(-5)
        }
        
        kCheckedView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 刷新布局
    private func refreshUI(){
        switch kPeriod {
        case .periodTimeLine:
            kIndexView.isHidden = true
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else { return }
                self.kIndexView.snp.remakeConstraints({ (make) in
                    make.right.equalTo(DefaultConst.kScreenHeight == 812 ? 80 : 50)
                    make.width.equalTo(DefaultConst.kScreenHeight == 812 ? 80 : 50)
                    make.top.equalTo(self.topInfoView.snp.bottom).offset(5)
                    make.bottom.equalTo(self.bottomView.snp.top).offset(-5)
                })
                self.kIndexView.layoutIfNeeded()
            }
        default:
            kIndexView.isHidden = false
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else { return }
                self.kIndexView.snp.remakeConstraints({ (make) in
                    make.right.equalTo(0)
                    make.width.equalTo(DefaultConst.kScreenHeight == 812 ? 80 : 50)
                    make.top.equalTo(self.topInfoView.snp.bottom).offset(5)
                    make.bottom.equalTo(self.bottomView.snp.top).offset(-5)
                })
                self.kIndexView.layoutIfNeeded()
            }
        }
    }
    
    private func request(){
        self.kLineView.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // ...loading date
            
            self.kLineView.stopLoading()
            self.kLineView.reloadData()
        }
    }
}

extension KLineFullScreenViewController : KLineViewDataSource {
    
    func kLineViewForType(_ kLineView: KLineView) -> KType {
        switch kPeriod {
        case .periodTimeLine:
            return .kTimeLine
        default:
            return .kLine
        }
    }
    
    func kLineViewForData(_ kLineView: KLineView) -> [KLineModel] {
        return kLineDataSource
    }
}
