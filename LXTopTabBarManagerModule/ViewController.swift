//
//  ViewController.swift
//  LXTopTabBarManagerModule
//
//  Created by Mac on 2020/6/21.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let topTabbar = LXTopTabBar(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 44), titles: ["服务", "技师", "商铺"])
        topTabbar.selectTitleFont = UIFont.systemFont(ofSize: 20)
        topTabbar.normalTitleFont = UIFont.systemFont(ofSize: 14)
        view.addSubview(topTabbar)
       
        topTabbar.selectButtonIndex = 2

        
        
        let contentView = LXContentView(frame: CGRect(x: 0, y: 144, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 144), childVcs: [UIViewController(),UIViewController(),UIViewController()], parentVc: self)
        view.addSubview(contentView)
        
        
        topTabbar.setHandle { (index) in
                   print("======\(index)")
            contentView.selectContentIndex = index
        }
        
        contentView.setHandle { (index) in
            topTabbar.selectButtonIndex = index
            print("======\(index)")
             
        }
        
    }
}

