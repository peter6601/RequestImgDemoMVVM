//
//  CaCheImageView.swift
//  RequestIImgDemo
//
//  Created by PeterDing on 2018/3/20.
//  Copyright © 2018年 DinDin. All rights reserved.
//

import Foundation
import UIKit

class CacheImageView: UIImageView {
    
    var cacheImage = NSCache<NSURL, UIImage>()
    var originRequsetURL: URL?
    var responseURL: URL?
    
    var currentTask: URLSessionTask? {
        didSet {
            oldValue?.cancel()
            currentTask?.resume()
        }
    }
    
    
    struct Configuration {
        var placeholderImage: UIImage? = nil
        var animationDuration: TimeInterval = 0.3
        var animationOptions: UIViewAnimationOptions = .transitionCrossDissolve
    }
    
    public var configuration = Configuration()
}


extension CacheImageView {
    
    func render(url: URL) {
        originRequsetURL = url
        
        if let imgFromCache = cacheImage.object(forKey: url as NSURL) {
            DispatchQueue.main.async { [weak self] in
                self?.image = imgFromCache
            }
        } else {
            image = configuration.placeholderImage
            currentTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let img = data else {
                    print("fail \(url)")
                    return
                }
                
                guard let responseURL = response?.url else { return }
                guard let orginURL = self.originRequsetURL, orginURL == responseURL else { return }
                print("download \(responseURL.absoluteString)")
                guard let image = UIImage(data: img) else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
                self.responseURL = responseURL
                self.cacheImage.setObject(image, forKey: url as NSURL)
            }
        }
    }
}
