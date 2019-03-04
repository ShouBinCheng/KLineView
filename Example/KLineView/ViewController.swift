//
//  ViewController.swift
//  KLineView
//
//  Created by iCoobin on 03/01/2019.
//  Copyright (c) 2019 iCoobin. All rights reserved.
//

import UIKit
import KLineView
import RxCocoa

class ViewController: UIViewController {

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

    //k线图
    private lazy var kLineView:KLineView = {
        let kLineView = KLineView()
        kLineView.delegate = self
        return kLineView
    }()
    
    /// k线按钮
    public lazy var kLineButton:UIButton = {
        let kLineButton = UIButton()
        kLineButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        kLineButton.setTitle(KLinePeriod.titleFor(kPeriod: self.kPeriod), for: .normal)
        kLineButton.setTitleColor(UIColor(hexString: "#8E9AB5"), for: .normal)
        kLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: .selected)
        kLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: [.selected,.highlighted])
        kLineButton.isSelected = true
        kLineButton.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: .highlighted)
        kLineButton.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: [.selected,.highlighted])
        kLineButton.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: .selected)
        return kLineButton
    }()
    
    //周期选择视图
    private lazy var kCheckedView:KLineChartCheckedView = {
        let kCheckedView = KLineChartCheckedView()
        kCheckedView.isHidden = true
        return kCheckedView;
    }()
    
    //全屏按钮
    private lazy var fullButton:UIButton = {
        let fullButton = UIButton();
        fullButton.setBackgroundImage(UIImage(named: "kline_button_full_normal"), for: .normal)
        return fullButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = KLineConst.kLineBgColor
        makeUI()
        makeEvent()
        makeConstraint()
        kLineView.reloadData()
        kLineView.setKIndexTop(index: .BOLL)
        kLineView.setKIndexBottom(index: .MACD)
    }
}

//MARK: - private
extension ViewController {

    private func makeUI() {
        self.view.addSubviews([kLineButton,fullButton,kLineView,kCheckedView]);
    }

    private func makeEvent(){
        let _ = kLineButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.kCheckedView.isHidden = false
            let frame = self.view.convert(self.kLineButton.frame, to: self.view)
            self.kCheckedView.refreshUI(frame: frame, kPeriod: self.kPeriod)
        })
        
        // k线周期按钮
        for button in kCheckedView.kPeriodButtons {
            let _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                
                let index = self.kCheckedView.kPeriodButtons.index(of: button)!
                self.kPeriod = KLinePeriod.kPeriodFor(index: index)!
                self.kCheckedView.isHidden = true
                let title = KLinePeriod.titleFor(kPeriod: self.kPeriod)
                self.kLineButton.setTitle(title, for: .normal)
                KLinePeriod.setDefaultKLinePeriod(self.kPeriod)
                self.request()
            })
        }
        //全屏按钮
        let _ = fullButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            let fullVC = KLineFullScreenViewController()
            self.present(fullVC, animated: true, completion: nil)
        })
    }
    
    private func makeConstraint() {
        kLineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(200)
            make.height.equalTo(300)
        }
        kLineButton.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.equalTo(15)
            make.width.equalTo(60)
            make.bottom.equalTo(kLineView.snp.top).offset(-15)
        }
        fullButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.right.equalTo(-15)
            make.bottom.equalTo(kLineView.snp.top).offset(-15)
        }
        kCheckedView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.navigationController?.present(KLineFullScreenViewController(), animated: true, completion: nil)
        self.kCheckedView.isHidden = true
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

extension ViewController : KLineViewDataSource {

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
