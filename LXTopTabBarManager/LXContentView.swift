//
//  LXContentView.swift
//  LXTopTabBarManagerModule
//
//  Created by Mac on 2020/6/21.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"
public class LXContentView: UIView {
   
    /// 回调函数
    public var callBack: TopTabBarCallBack?
    
    /// 选中的索引 对应的内容
    public var selectIndex: Int = 0 {
       didSet {
          setContent(select: selectIndex, animation: true)
       }
    }
     
    private var childVcs: [UIViewController]
    private weak var parentVc: UIViewController?
    private lazy var layout: UICollectionViewFlowLayout = {
          let layout = UICollectionViewFlowLayout()
          layout.itemSize = bounds.size
          layout.minimumLineSpacing = 0
          layout.minimumInteritemSpacing = 0
          layout.scrollDirection = .horizontal
          return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    /// 指定构造器
    public init(frame: CGRect,
                childVcs: [UIViewController],
                parentVc: UIViewController?)
    {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

 
// MARK: - public 扩展
extension LXContentView {
    
    /// 给外界回调 滚动内容时的回调
     public func setHandle(_ callBack: TopTabBarCallBack?) {
        self.callBack = callBack
     }
     
     /// 设置内容滚动位置
     public func setContent(select index: Int, animation: Bool) {
        // 边界处理
        if index >= childVcs.count || index < 0 { return }
        // 滚动 的位置
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: animation)
     }
}

extension LXContentView {
    
    /// 初始化UI
    private func setupUI() {
        //添加子控制器到父控制器中
        for childVc in childVcs {
            parentVc?.addChild(childVc)
        }
        //添加UICollection
        addSubview(collectionView)
    }
}

// MARK: - UICollectionViewDataSource
extension LXContentView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}


// MARK:- UICollectionView的delegate
extension LXContentView: UICollectionViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
          //获取滚动到的位置
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        callBack?(index)
    }
}
