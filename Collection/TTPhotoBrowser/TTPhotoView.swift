//
//  TTPhotoView.swift
//  Collection
//
//  Created by Wong on 17/2/18.
//  Copyright © 2017年 collection. All rights reserved.
//

import UIKit

protocol TTPhotoViewDelegate:NSObjectProtocol {
    func singleTap()
}

class TTPhotoView: UIScrollView, UIScrollViewDelegate {
    
    var photoView: UIImageView?
    var singleDelegate:TTPhotoViewDelegate?
    
    private let MaxSCale:CGFloat = 2.0
    private let MinScale:CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeUI()
    }
    
    private func initializeUI() {
        self.delegate = self
        self.minimumZoomScale = MinScale
        self.maximumZoomScale = MaxSCale
        self.contentSize = self.bounds.size
        
        photoView = UIImageView(frame: self.bounds)
        photoView?.isUserInteractionEnabled = true
        photoView?.contentMode = .scaleAspectFit
        self.addSubview(photoView!)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(fingerIncident(tap:)))
        singleTap.numberOfTouchesRequired = 1
        singleTap.numberOfTapsRequired = 1
        photoView?.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(fingerIncident(tap:)))
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        photoView?.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
    }
    
    var photo:UIImage? {
        didSet {
            photoView?.image = photo
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }
        
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageview = scrollView.subviews.first as! UIImageView
        self.centerShow(scrollview: scrollView, imageview: imageview)
    }
    
    func centerShow(scrollview:UIScrollView, imageview:UIImageView) {
        let offsetX = (scrollview.bounds.size.width > scrollview.contentSize.width) ? (scrollview.bounds.size.width - scrollview.contentSize.width) * 0.5 : 0.0;
        let offsetY = (scrollview.bounds.size.height > scrollview.contentSize.height) ?
            (scrollview.bounds.size.height - scrollview.contentSize.height) * 0.5 : 0.0;
        imageview.center = CGPoint(x: scrollview.contentSize.width * 0.5 + offsetX, y: scrollview.contentSize.height * 0.5 + offsetY)
    }
    
    func fingerIncident(tap:UITapGestureRecognizer) {
        if (tap.numberOfTouchesRequired == 1) {
            if(tap.numberOfTapsRequired == 1) {
                if singleDelegate != nil {
                    singleDelegate?.singleTap()
                }
            } else if(tap.numberOfTapsRequired == 2 ){
                var newScale:CGFloat
                if self.zoomScale == MinScale {
                    newScale = MaxSCale
                } else {
                    newScale = 0.0
                }
                let zoomRect = self.zoomRectForScale(scale: newScale, center: tap.location(in: tap.view))
                self.zoom(to: zoomRect, animated: true)
            }
        }
    }
    
    func zoomRectForScale(scale:CGFloat, center:CGPoint) -> CGRect {
        var zoomRect = self.frame
        zoomRect.size.height = self.frame.size.height/scale
        zoomRect.size.width  = self.frame.size.width/scale
        zoomRect.origin.x = center.x - (zoomRect.size.width/2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height/2.0)
        return zoomRect
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
