//
//  ListInfo.swift
//  RequestIImgDemo
//
//  Created by PeterDing on 2018/3/20.
//  Copyright © 2018年 DinDin. All rights reserved.
//

import Foundation

struct  ListInfo {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: String?
    var photo: [Photo]?
    

}


enum ListKeys: String, CodingKey {
    case page, pages, perpage, total, photo
}

enum RootKeys: String, CodingKey {
    case photos
}

extension ListInfo: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let listContainer = try container.nestedContainer(keyedBy: ListKeys.self, forKey: .photos)
        page = try listContainer.decode(Int.self, forKey: .page)
        pages = try listContainer.decode(Int.self, forKey: .pages)
        perpage = try listContainer.decode(Int.self, forKey: .perpage)
        total = try listContainer.decode(String.self, forKey: .total)
        photo = try listContainer.decodeIfPresent([Photo].self, forKey: .photo)

    }
}
