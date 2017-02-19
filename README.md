# TTPhotoBrowser

使用如下

let browser = TTPhotoBrowser() <br>
browser.photos = images as! [UIImage] <br>
browser.browserType = .edit <br>
//当browserType = .edit时  调用block <br>
browser.block = ({ index in <br>
>>images.remove(at: index) <br>
>>//index（删除图片位置的索引）<br>
>>//刷新当前界面 <br>

})

self.navigationController?.pushViewController(browser, animated: true)
