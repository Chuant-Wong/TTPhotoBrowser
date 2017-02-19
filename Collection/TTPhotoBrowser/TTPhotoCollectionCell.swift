//
//  TTPhotoCollectionCell.swift
//  Collection
//
//  Created by Wong on 17/2/18.
//  Copyright © 2017年 collection. All rights reserved.
//

import UIKit

protocol TTPhotoCollectionCellDelegate:NSObjectProtocol {
    func photoImage(selected cell:TTPhotoCollectionCell)
}

class TTPhotoCollectionCell: UICollectionViewCell, TTPhotoViewDelegate {

    var delegate:TTPhotoCollectionCellDelegate?
    private var photoView:TTPhotoView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeUI()
    }
    
    private  func initializeUI() {
        self.backgroundColor = UIColor.black
        photoView = TTPhotoView(frame: self.contentView.bounds)
        photoView?.singleDelegate = self
        self.addSubview(photoView!)
    }
    
    var photoImage:UIImage? {
        didSet {
            photoView?.photo = photoImage
        }
    }
    
    func singleTap() {
        if delegate != nil {
            delegate?.photoImage(selected: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

