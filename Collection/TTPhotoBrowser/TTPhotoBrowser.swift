//
//  TTPhotoBrowser.swift
//  Collection
//
//  Created by Wong on 17/2/18.
//  Copyright © 2017年 collection. All rights reserved.
//

import UIKit

enum TTBrowserType:Int {
    case show = 1 //纯展示图片（默认）
    case edit = 2 //删除图片
}

class TTPhotoBrowser: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, TTPhotoCollectionCellDelegate {
    
    private let photoCell = "photoCell"
    
    var photos = [UIImage]()
    var currentPage:Int = 1
    var browserType:TTBrowserType = .show//默认展示
    var block:((_ indexOfRomovedImage:Int) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(collectionView)
        
        collectionView.register(TTPhotoCollectionCell.self, forCellWithReuseIdentifier: photoCell)
        let indexPath = IndexPath(row: currentPage - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "\(self.currentPage)/\(self.photos.count)"
        self.navigationItem.rightBarButtonItem = self.browserType == .edit ? UIBarButtonItem(customView: deleteBtn) : nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.setStatusBarHidden(true, with: .slide)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCell, for: indexPath) as! TTPhotoCollectionCell
        cell.photoImage = photos[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func photoImage(selected cell: TTPhotoCollectionCell) {
        if (self.navigationController?.navigationBar.isHidden)! {
            UIApplication.shared.setStatusBarHidden(false, with: .slide)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            UIApplication.shared.setStatusBarHidden(true, with: .slide)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 50.0, height: 40.0)
        btn.setTitle("删除", for: .normal)
        btn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return btn
    }()
    
    func deleteAction() {
        
        let alert = UIAlertController(title: nil, message: "要删除这张照片吗？", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { (action) in
            let indexPath = self.collectionView.indexPathsForVisibleItems[0]
            if self.block != nil {
                self.block!(indexPath.row)
            }
            self.photos.remove(at: indexPath.row)
            if self.photos.count == 0 {
                _ = self.navigationController?.popViewController(animated: true)
                return
            }
            self.collectionView.deleteItems(at: [indexPath])
            if indexPath.row >= self.photos.count {
                self.currentPage = self.photos.count
            } else if indexPath.row == 0 {
                self.currentPage = 1
            } else {
                self.currentPage = indexPath.row + 1
            }
            self.title = "\(self.currentPage)/\(self.photos.count)"
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    lazy var collectionView: UICollectionView = {
        let layoutFlow = UICollectionViewFlowLayout()
        layoutFlow.minimumLineSpacing = 0
        layoutFlow.minimumInteritemSpacing = 0
        layoutFlow.scrollDirection = .horizontal
        layoutFlow.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 1.0)
        let cv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layoutFlow)
        cv.backgroundColor = UIColor.black
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIApplication.shared.setStatusBarHidden(true, with: .slide)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let indexPath = self.collectionView.indexPathsForVisibleItems[0]
        self.currentPage = indexPath.row + 1;
        self.title = "\(self.currentPage)/\(self.photos.count)"

        
        if scrollView is UICollectionView {
            for collectionViewSubview in scrollView.subviews {
                if collectionViewSubview is TTPhotoCollectionCell {
                    for cellSubview in collectionViewSubview.subviews {
                        if cellSubview is TTPhotoView {
                            let photoView = cellSubview as! TTPhotoView
                            photoView.setZoomScale(1.0, animated: true)
                        }
                    }
                }
            }
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
