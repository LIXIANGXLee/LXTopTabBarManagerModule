//
//  LXTestViewController.swift
//  LXTopTabBarManagerModule
//
//  Created by Mac on 2020/6/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

class LXTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
print("-=-=-==\(view.frame)")

        view.backgroundColor = UIColor.red
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("-=-=-==\(view.frame)")
    }
    
    

}
