//
//  LXTopTabBar.swift
//  LXTopTabBarManagerModule
//
//  Created by Mac on 2020/6/21.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXFitManager

public struct LXItem {
    public var title: String
    public var image: UIImage?
    public var selectImage: UIImage?

    public init(title: String,
                image: UIImage? = nil,
                selectImage: UIImage? = nil)
    {
        self.title = title
        self.image = image
        self.selectImage = selectImage
    }
}


public typealias TopTabBarCallBack = (Int) -> Void
public class LXTopTabBar: UIView {

    /// 下划线颜色
    public var bottomLineColor: UIColor = UIColor.red {
        didSet { bottomLine.backgroundColor = bottomLineColor }
    }
    
    /// 下划线高度
    public var bottomLineH: CGFloat = LXFit.fitFloat(2){
        didSet {
            bottomLine.frame.size.height = bottomLineH
            bottomLine.frame.origin.y = bounds.height - bottomLineH
            bottomLine.layer.cornerRadius = bottomLineH * 0.5
        }
    }
    
    /// 默认title颜色
    public var normalTitleColor: UIColor = UIColor.lightGray {
        didSet {
            for button in buttons {
                button.setTitleColor(normalTitleColor, for: .normal)
            }
        }
    }
    
    /// 选中title颜色
    public var selectTitleColor: UIColor = UIColor.red {
       didSet {
            for button in buttons {
                button.setTitleColor(selectTitleColor, for: .selected)
            }
        }
    }
    
    /// 选中title字体大小
    public var selectTitleFont: UIFont = UIFont.systemFont(ofSize: 16).fitFont {
        didSet {
            for button in buttons {
               if button == lastSelectButton {
                  button.titleLabel?.font = selectTitleFont
               }
            }
        }
    }

    /// 默认title字体大小
    public var normalTitleFont: UIFont = UIFont.systemFont(ofSize: 16).fitFont {
           didSet {
               for button in buttons {
                  if button != lastSelectButton {
                     button.titleLabel?.font = normalTitleFont
                  }
               }
           }
       }
    
    
    /// 先设置setHandle或者callBack 回调 才执行
      public var selectButtonIndex: Int = 0 {
         didSet {
            if selectButtonIndex >= buttons.count || selectButtonIndex < 0 { return }
                buttonClick(buttons[selectButtonIndex])
         }
      }
    
     /// 外界回调
     public var callBack: TopTabBarCallBack?
    
     fileprivate lazy var currentIndex: Int = 0
     fileprivate var titleItems: [LXItem]
     fileprivate var Button: UIButton.Type
     fileprivate lazy var buttons = [UIButton]()
     fileprivate var lastSelectButton: UIButton?

     fileprivate lazy var bottomLine: UIView = {
         let bottomLine = UIView()
         bottomLine.backgroundColor = bottomLineColor
         bottomLine.frame.size.height = bottomLineH
         bottomLine.frame.origin.y = bounds.height - bottomLineH
         bottomLine.layer.cornerRadius = bottomLineH * 0.5
         bottomLine.clipsToBounds = true
         return bottomLine
     }()
         
    /// 指定构造器
    /// titleItems 标题内容
    /// Button 外部的button只建议修改图文布局 颜色 大小 请设置属性
    public init(frame: CGRect,
                titleItems: [LXItem],
                Button: UIButton.Type)
    {
        self.titleItems = titleItems
        self.Button = Button
        super.init(frame: frame)
        setupItemUI()
    }
    
     required public init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}


extension LXTopTabBar {
    /// 初始化UI界面
    fileprivate func setupItemUI() {
        
        //添加button到view上
        setupItemButtons()
        
        //设置Button的frame
        setupButtonsFrame()
        
        //添加滚动条
        addSubview(bottomLine)

    }

    /// 初始化button
    private func setupItemButtons() {
                
        for (i, item) in titleItems.enumerated() {
            var button: UIButton
            if i >= buttons.count {
                button = Button.init(type: .custom)
                button.titleLabel?.textAlignment = .center
                button.adjustsImageWhenHighlighted = false
                addSubview(button)
                buttons.append(button)
                button.addTarget(self, action: #selector(buttonClick(_:)), for: UIControl.Event.touchUpInside)
            }else {
                button = buttons[i]
            }
            
            button.setTitle(item.title, for: .normal)
            button.titleLabel?.font = normalTitleFont
            button.setTitleColor(normalTitleColor, for: .normal)
            button.setTitleColor(selectTitleColor, for: .selected)
            button.tag = i
            if let image = item.image {
               button.setImage(image, for: .normal)
            }
            if let seletImage = item.selectImage {
               button.setImage(seletImage, for: .selected)
            }
        }
    }
   
    /// 尺寸布局
    private func setupButtonsFrame() {
        
        for (i, button) in buttons.enumerated() {
            let w: CGFloat = self.frame.width / CGFloat(titleItems.count)
            let h: CGFloat = self.frame.height
            let y: CGFloat = 0
            button.frame = CGRect(x: w * CGFloat(i), y: y, width: w, height: h)
            if i == selectButtonIndex {
                buttonClick(button)
            }
        }
    }
}

// MARK:- public 监听事件
extension LXTopTabBar {
    
    /// 给外界回调
    public func setHandle(_ callBack: TopTabBarCallBack?) {
         self.callBack = callBack
     }
    
}

// MARK:- private 监听事件
extension LXTopTabBar {
    
    /// button点击事件
    @objc private func buttonClick(_ button: UIButton) {
       setSelectButton(button: button)
       setLineX(button: button)
       callBack?(button.tag)
    }
    
    /// 设置线的位置
    private func setLineX(button: UIButton) {
        bottomLine.frame.size.width = button.titleLabel?.text?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: button.titleLabel!.font!], context: nil).width ?? 0
           
        UIView.animate(withDuration: 0.2) {
            self.bottomLine.center.x = button.center.x
        }
    }
    
    /// 设置选中的button
    private func setSelectButton(button: UIButton) {
        self.lastSelectButton?.isSelected = false
        self.lastSelectButton?.titleLabel?.font = normalTitleFont
        button.isSelected = true
        button.titleLabel?.font = selectTitleFont
        self.lastSelectButton = button
    }
}

