//
//  Photo.swift
//  RequestIImgDemo
//
//  Created by PeterDing on 2018/3/19.
//  Copyright © 2018年 DinDin. All rights reserved.
//


import Foundation



struct Photo: Codable {
    
    var farm : Int!
    var id : String!
    var isfamily : Int!
    var isfriend : Int!
    var ispublic : Int!
    var owner : String!
    var secret : String!
    var server : String!
    var title : String!

    
    func getURL() -> String {
        return "https://farm\(self.farm ?? 0).staticflickr.com/\(self.server ?? "")/\(self.id ?? "")_\(self.secret ?? "").jpg"
    }
}
