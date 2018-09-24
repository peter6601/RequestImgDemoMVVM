//
//  ListViewModel.swift
//  RequestIImgDemo
//
//  Created by PeterDing on 2018/3/19.
//  Copyright © 2018年 DinDin. All rights reserved.
//

import Foundation

protocol  ListViewModelDataSourceProtocol {
    func requestAPI(page: Int, completion: @escaping ()->(), error:@escaping ()->() )
}

enum PhotoListType: String {
    case People
    case Cars
    case Landscape
    case Trip
}


class ListViewModel {
    
    fileprivate var photoList: [Photo] = [] {
        didSet {
            updateData?()
        }
    }
    
    private var type: PhotoListType = .People
    
    var updateData: (()->())?
    
    init(type: PhotoListType ) {
        self.type = type
    }
    
    private var page: Int = 0
    
    subscript(_ number: Int) -> Photo {
        return photoList[number]
    }
    
    var count: Int {
        get {
           return  photoList.count
        }
    }
    
    
    
    func requestAPI(completion: @escaping ()->(), error:@escaping ()->() ) {
        APIManager.shared.getSearchRequest(text: type.rawValue, url: TestURL.getSearch.rawValue, page: page) { (data, err) in
            guard let photos = data else { return }
            
            DispatchQueue.main.async {[weak self] in
                self?.photoList += photos
                self?.page += 1
                completion()
            }
        }
    }
}

