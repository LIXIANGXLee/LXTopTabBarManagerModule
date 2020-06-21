//
//  LXContentView.swift
//  LXTopTabBarManagerModule
//
//  Created by Mac on 2020/6/21.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"

public typealias ContentViewCallBack = (Int) -> Void
public class LXContentView: UIView {
    
    /// 选中的索引
    public var selectContentIndex: Int = 0 {
        didSet {
           if selectContentIndex >= childVcs.count || selectContentIndex < 0 { return }
            let indexPath = IndexPath(item: selectContentIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        }
     }
    
    public var callBack: ContentViewCallBack?
    
    fileprivate var childVcs: [UIViewController]
    fileprivate weak var parentVc: UIViewController?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
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

extension LXContentView {
    /// 给外界回调
     public func setHandle(_ callBack: ContentViewCallBack?) {
          self.callBack = callBack
      }
     
}

extension LXContentView {
    fileprivate func setupUI() {
        //添加子控制器到父控制器中
        for childVc in childVcs {
            parentVc?.addChild(childVc)
        }
        //添加UICollection
        addSubview(collectionView)
    }
}


extension LXContentView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
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
