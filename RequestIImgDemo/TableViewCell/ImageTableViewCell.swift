//
//  ImageTableViewCell.swift
//  RequestIImgDemo
//
//  Created by PeterDing on 2018/3/20.
//  Copyright © 2018年 DinDin. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: CacheImageView! 
    
    @IBOutlet weak var progressView: UIProgressView!
    var photo: Photo?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(photo: Photo) {
        self.photo = photo
        guard let url = URL(string:photo.getURL()) else { return }
        self.mainImageView.render(url: url)
//        self.mainImageView.downloadFromServer(urlString: photo.getURL())
        print(photo.getURL())

    }
}
