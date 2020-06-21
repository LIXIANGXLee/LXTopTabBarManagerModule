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
       
        let item1 = LXItem(title: "服务",image: UIImage(named: "my_setting"))
        let item2 = LXItem(title: "技师",image: UIImage(named: "my_setting"))
        let item3 = LXItem(title: "商铺",image: UIImage(named: "my_setting"))

        let topTabbar = LXTopTabBar(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 72), titleItems: [item1,item2,item3], Button: Otherbutton.self)
        
        topTabbar.selectTitleColor = UIColor.orange
        topTabbar.normalTitleColor = UIColor.purple
        
        topTabbar.selectTitleFont = UIFont.systemFont(ofSize: 20)
        topTabbar.normalTitleFont = UIFont.systemFont(ofSize: 14)
        
        
        view.addSubview(topTabbar)
       
       
        
        let contentView = LXContentView(frame: CGRect(x: 0, y: topTabbar.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - topTabbar.frame.maxY), childVcs: [UIViewController(),UIViewController(),UIViewController()], parentVc: self)
        view.addSubview(contentView)
        
        
        topTabbar.setHandle { (index) in
                   print("======\(index)")
            contentView.selectContentIndex = index
        }
        
        contentView.setHandle { (index) in
            topTabbar.selectButtonIndex = index
            print("======\(index)")
             
        }
             
        topTabbar.selectButtonIndex = 2
        
    }
}

class Otherbutton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: LXFit.fitFloat(55), width: contentRect.width, height: LXFit.fitFloat(15))
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: (contentRect.width - LXFit.fitFloat(45)) * 0.5, y: 0, width: LXFit.fitFloat(45), height: LXFit.fitFloat(45))
    }
}
