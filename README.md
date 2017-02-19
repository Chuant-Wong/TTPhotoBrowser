# TTPhotoBrowser

let browser = TTPhotoBrowser()

browser.photos = images as! [UIImage]

browser.browserType = .edit

//当browserType = .edit时  调用block

browser.block = ({ index in

images.remove(at: index)

//index（删除图片位置的索引）

//刷新当前界面

})

self.navigationController?.pushViewController(browser, animated: true)
