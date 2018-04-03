//
//  APIManager.swift
//  RequestIImgDemo
//
//  Created by PeterDing on 2018/3/20.
//  Copyright © 2018年 DinDin. All rights reserved.
//

import Foundation
import UIKit

enum ErrorApi: String, Error {
    case WrongURL = "Wrong URL"
    case CanNotParse = "Can Not Parse"
}



enum TestURL: String {
    case getSearch = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=2bee7a538cfb6b734101845074051098&"
}

class APIManager {
    
    static let shared = APIManager()
    func getSearchRequest(text:String = "", url: String, page: Int = 0, completion: @escaping ([Photo]?, ErrorApi?) -> Void) {
        var tempKeyword = text
        if text == "" {
            tempKeyword = "People"
        }
        let urlPath = "text=\(tempKeyword)&per_page=10&page=\(page)&format=json&nojsoncallback=1"
        let fixURL = url + urlPath
        guard let path = URL(string: fixURL) else {
            completion(nil, ErrorApi.WrongURL);
            return
            
        }
        
        let headers = [
            "x-parse-application-id": "vqYuKPOkLQLYHhk4QTGsGKFwATT4mBIGREI2m8eD",
        ]
        var request = URLRequest(url: path)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let download = data else {
                completion(nil, error as? ErrorApi)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion(nil, error as? ErrorApi)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let result = try decoder.decode(ListInfo.self, from: download)
                
                completion(result.photo, nil)
            } catch {
                completion(nil, ErrorApi.CanNotParse)
            }
        }
        task.resume()
    }
    
}

extension UIImageView {
    
    func downloadFromServer(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let img = data else {
              print("fail \(url)")
                return
            }
            let image = UIImage(data: img)
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}
