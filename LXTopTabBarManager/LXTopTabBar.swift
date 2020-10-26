//
//  LXTopTabBar.swift
//  LXTopTabBarManagerModule
//
//  Created by Mac on 2020/6/21.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXFitManager

public enum TopTabBarType {
    case none  // 隐藏红点
    case red   // 显示红点
    case count // 显示数量
}

/// 回调生命
public typealias TopTabBarCallBack = (Int) -> Void
public protocol LXTopTabBarDelegate: AnyObject {
    func titleRect(forContentRect contentRect: CGRect) -> CGRect
    func imageRect(forContentRect contentRect: CGRect) -> CGRect
}

public class LXTopTabBar: UIView {
    
    /// 有图片和文字时 设置其代理
    public weak var  delegate: LXTopTabBarDelegate? {
        didSet {
            guard let delegate = delegate else { return }
            for button in allItems {
                button.delegate = delegate
            }
        }
    }

    /// 下划线颜色
    public var bottomLineColor: UIColor = UIColor.red {
        didSet { bottomLine.backgroundColor = bottomLineColor }
    }
     
    /// 下划线Y坐标
    public var bottomLineY: CGFloat?{
        didSet {
            guard let bottomLineY = bottomLineY else { return }
            bottomLine.frame.origin.y = bottomLineY
        }
    }

    /// 下划线高度
    public var bottomLineH: CGFloat = LXFit.fitFloat(2){
        didSet {
            bottomLine.frame.size.height = bottomLineH
            bottomLine.frame.origin.y = bounds.height - bottomLineH
            bottomLine.layer.cornerRadius = bottomLineH * 0.5
        }
    }
    
    
    /// 下划线宽度
    public var bottomLineW: CGFloat?{
        didSet {
            guard let bottomLineW = bottomLineW else { return }
            bottomLine.frame.size.width = bottomLineW
        }
    }

    
    ///下划线是否均分
    public var bottomLineAverage: Bool = false{
        didSet {
            bottomLine.frame.size.width = bounds.width / CGFloat(allItems.count)
        }
    }
    
    /// 默认title颜色
    public var normalTitleColor: UIColor = UIColor.lightGray {
        didSet {
            for button in allItems {
                button.normalTitleColor = normalTitleColor
            }
        }
    }
    
    /// 选中title颜色
    public var selectTitleColor: UIColor = UIColor.red {
       didSet {
            for button in allItems {
                button.selectTitleColor = selectTitleColor
            }
        }
    }
    
    /// 选中title字体大小
    public var selectTitleFont: UIFont = UIFont.systemFont(ofSize: 16).fitFont {
        didSet {
            for button in allItems {
               if button == lastSelectButton {
                  button.selectTitleFont = selectTitleFont
               }
            }
        }
    }

    /// 默认title字体大小
    public var normalTitleFont: UIFont = UIFont.systemFont(ofSize: 16).fitFont {
           didSet {
               for button in allItems {
                  if button != lastSelectButton {
                     button.normalTitleFont = normalTitleFont
                  }
               }
           }
       }
    
    /// 先设置setHandle或者callBack 回调  初始化回调 才执行
      public var selectIndex: Int = 0 {
         didSet { setTabBar(select: selectIndex) }
      }
    
     /// 回调函数
     public var callBack: TopTabBarCallBack?
     /// 所有item集合
     public var allItems = [LXTopButton]()

     private var titleModels: [LXTitleModel]
     private var lastSelectButton: LXTopButton?

     private lazy var bottomLine: UIView = {
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
                titleModels: [LXTitleModel])
    {
        self.titleModels = titleModels
        super.init(frame: frame)
        setupItemUI()
    }
    
     required public init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}

// MARK:- public 监听事件
extension LXTopTabBar {
    
    /// 给外界回调
    public func setHandle(_ callBack: TopTabBarCallBack?) {
         self.callBack = callBack
    }
    
    /// 设置tabbar选中位置
    public func setTabBar(select index: Int) {
        if index >= allItems.count || index < 0 { return }
        buttonClick(allItems[index])
    }
    
    /// 统一设置小红点位置 如果设置单个 可调用 allItems 中的 redViewPoint
    public func setRedPoint(x: CGFloat, y: CGFloat) {
        for button in allItems {
           button.redViewPoint = CGPoint(x: x, y: y)
        }
    }
    
    /// 统一设置小红点大小  如果设置单个 可调用 allItems 中的 redViewSize
    public func setRedSize(size: CGFloat) {
        for button in allItems {
           button.redViewSize = size
        }
    }
}

extension LXTopTabBar {
    /// 初始化UI界面
    private func setupItemUI() {
        
        //添加button到view上
        setupItemButtons()
        
        //设置Button的frame
        setupButtonsFrame()
        
        //添加滚动条
        addSubview(bottomLine)

    }

    /// 初始化button
    private func setupItemButtons() {
                
        for (i, model) in titleModels.enumerated() {
            let topButton = LXTopButton(type: .custom)
            addSubview(topButton)
            allItems.append(topButton)
            topButton.tag = i
            topButton.title  = model.title
            topButton.normalTitleFont = normalTitleFont
            topButton.selectTitleColor  = selectTitleColor
            topButton.normalTitleColor  = normalTitleColor
            topButton.normalImage  = model.image
            topButton.selectedImage  = model.selectImage
            topButton.addTarget(self, action: #selector(buttonClick(_:)), for:.touchUpInside)
            
        }
    }
   
    /// 尺寸布局
    private func setupButtonsFrame() {
        
        let w: CGFloat = self.frame.width / CGFloat(allItems.count)
        let h: CGFloat = self.frame.height
        for (i, button) in allItems.enumerated() {
            button.frame = CGRect(x: w * CGFloat(i), y: 0, width: w, height: h)
            if i == selectIndex {
                buttonClick(button)
            }
        }
    }
}

// MARK:- private 监听事件
extension LXTopTabBar {
    
    /// button点击事件
    @objc private func buttonClick(_ button: LXTopButton) {
       setSelectButton(button: button)
       setLineX(button: button)
       callBack?(button.tag)
    }
    
    /// 设置线的位置
    private func setLineX(button: UIButton) {
        
        if !bottomLineAverage && self.bottomLineW == nil {
            bottomLine.frame.size.width  = button.titleLabel?.text?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: button.titleLabel!.font!], context: nil).width ?? 0
        }
        
        UIView.animate(withDuration: 0.15) {
            self.bottomLine.center.x = button.center.x
        }
    }
    
    /// 设置选中的button
    private func setSelectButton(button: LXTopButton) {
        self.lastSelectButton?.isSelected = false
        self.lastSelectButton?.normalTitleFont = normalTitleFont
        button.isSelected = true
        button.selectTitleFont = selectTitleFont
        self.lastSelectButton = button
    }
}

public class LXTopButton: UIButton {
    public var title: String? {
        didSet {
            guard let title = title else { return }
            setTitle(title, for: .normal)
        }
    }
    
    public var selectTitleFont: UIFont? {
        didSet {
            guard let selectTitleFont = selectTitleFont else { return }
            titleLabel?.font = selectTitleFont
        }
    }
     
    public var normalTitleFont: UIFont? {
       didSet {
           guard let normalTitleFont = normalTitleFont else { return }
         titleLabel?.font = normalTitleFont
       }
    }
    
    public var selectTitleColor: UIColor? {
       didSet {
           guard let selectTitleColor = selectTitleColor else { return }
          setTitleColor(selectTitleColor, for: .selected)
       }
    }
    
    public var normalTitleColor: UIColor? {
        didSet {
            guard let normalTitleColor = normalTitleColor else { return }
            setTitleColor(normalTitleColor, for: .normal)
        }
    }

    public var normalImage: UIImage? {
         didSet {
            guard let normalImage = normalImage else { return }
            setImage(normalImage, for: .normal)
        }
    }
    
    public var selectedImage: UIImage? {
        didSet {
            guard let selectedImage = selectedImage else { return }
            setImage(selectedImage, for: .selected)
        }
    }
    
    public var redViewSize: CGFloat = LXFit.fitFloat(5){
        didSet { setNeedsLayout() }
    }
    
    public var redViewPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet { setNeedsLayout() }
    }
    
    public var type: TopTabBarType = .none {
        didSet {
            if type != .count{
                redView.setTitleColor(UIColor.clear, for: .normal)
            }
            redView.isHidden = type == .none
        }
    }
    
    public var redViewBackgroundColor: UIColor = UIColor.red {
        didSet { redView.backgroundColor = redViewBackgroundColor }
    }
    
    public var redViewCount: Int = 0 {
        didSet { redView.setTitle("\(redViewCount)", for: .normal)}
    }
    
    public var redViewTitleFont: UIFont = UIFont.systemFont(ofSize: 14).fitFont {
        didSet { redView.titleLabel?.font = redViewTitleFont}
    }
    
    public var redViewTitleColor: UIColor = UIColor.white {
        didSet { redView.setTitleColor(redViewTitleColor, for: .normal)}
     }
     
    private lazy var redView: UIButton = {
        let redView = UIButton(type: .custom)
        redView.backgroundColor = redViewBackgroundColor
        return redView
    }()
    
    public weak var  delegate: LXTopTabBarDelegate?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(redView)
        titleLabel?.textAlignment = .center
        adjustsImageWhenHighlighted = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if type == .red {
            redView.frame = CGRect(origin: redViewPoint, size: CGSize(width: redViewSize, height: redViewSize))
        }else if type == .count {
            let w = redView.titleLabel?.attributedText?.boundingRect(with: CGSize(width: LXFit.fitFloat(100), height: redViewSize), options: .usesLineFragmentOrigin, context: nil).size.width ?? 0
            redView.frame = CGRect(origin: redViewPoint, size: CGSize(width: max(w + LXFit.fitFloat(10), redViewSize) , height: redViewSize))
        }
        
        redView.layer.cornerRadius = redViewSize * 0.5
        redView.clipsToBounds = true
    }
    
    public override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return delegate?.titleRect(forContentRect: contentRect) ?? bounds
    }

    public override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return delegate?.imageRect(forContentRect: contentRect) ?? CGRect.zero
    }
}

public struct LXTitleModel {
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
