//
//  ViewController.swift
//  LXTopTabBarManagerModule
//
//  Created by Mac on 2020/6/21.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXFitManager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let item1 = LXTitleModel(title: "服务",image: UIImage(named: "my_setting"))
        let item2 = LXTitleModel(title: "技师",image: UIImage(named: "my_setting"))
        let item3 = LXTitleModel(title: "商铺",image: UIImage(named: "my_setting"))
        
        
//        let item1 = LXTitleModel(title: "服务")
//        let item2 = LXTitleModel(title: "技师")
//        let item3 = LXTitleModel(title: "商铺")

        let topTabbar = LXTopTabBar(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 70), titleModels: [item1,item2,item3])
        topTabbar.delegate = self
        topTabbar.selectTitleColor = UIColor.orange
        topTabbar.normalTitleColor = UIColor.purple
        topTabbar.selectTitleFont = UIFont.systemFont(ofSize: 20)
        topTabbar.normalTitleFont = UIFont.systemFont(ofSize: 19)
//        topTabbar.bottomLineAverage = true
        topTabbar.bottomLineColor = UIColor.blue
        view.addSubview(topTabbar)
       
       
        
        let contentView = LXContentView(frame: CGRect(x: 0, y: topTabbar.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - topTabbar.frame.maxY), childVcs: [LXTestViewController(),LXTestViewController(),LXTestViewController()], parentVc: self)
        view.addSubview(contentView)
        
        
        topTabbar.setHandle { (index) in
                   print("======\(index)")
            contentView.selectIndex = index
        }
        
        contentView.setHandle { (index) in
            topTabbar.selectIndex = index
            print("======\(index)")
             
        }
             
        topTabbar.selectIndex = 2
        
    }
}

extension ViewController: LXTopTabBarDelegate {
     func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: LXFit.fitFloat(35), width: contentRect.width, height: LXFit.fitFloat(20))
    }
    
    func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: (contentRect.width - LXFit.fitFloat(30)) * 0.5, y: 0, width: LXFit.fitFloat(30), height: LXFit.fitFloat(30))
    }
}

