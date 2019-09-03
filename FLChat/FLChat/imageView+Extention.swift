//
//  imageView+Extention.swift
//  FLChat
//
//  Created by Fedor Losev on 03/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit



extension UIImageView {
    func loadImageUsingCachWithUrl(_ urlString: String){
        let imageCache = NSCache<AnyObject, AnyObject>()
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, responce, error) in
            if error != nil {
                print("Cant convert the url for image: \(String(describing: error?.localizedDescription))")
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: url as AnyObject )
                    self.image = downloadedImage
                }
            }
        }).resume()
    }
}


