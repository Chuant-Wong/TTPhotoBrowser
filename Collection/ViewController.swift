//
//  ViewController.swift
//  Collection
//
//  Created by Wong on 17/2/18.
//  Copyright © 2017年 collection. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func nextPageAction(_ sender: UIButton) {
        
        let image1 = UIImage(named: "photo1.JPG")
        let image2 = UIImage(named: "photo2.JPG")
        let image3 = UIImage(named: "photo3.JPG")
        let image4 = UIImage(named: "photo4.JPG")
        
        var images = [image1, image2 ,image3, image4]
        
        let nextPage = TTPhotoBrowser()
        nextPage.photos = images as! [UIImage]
        nextPage.browserType = .edit
        nextPage.block = ({ index in
            images.remove(at: index)
            print("imagesCount = \(images.count) index = \(index)")
        })
        self.navigationController?.pushViewController(nextPage, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

