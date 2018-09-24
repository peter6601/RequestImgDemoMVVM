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
    case getSearch = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=9f8fe691e41c5db8b534d0f0d4cb4d6f&"
}


protocol URLSessionProtocol {
    
    func dataTaskTo(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol  {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func dataTaskTo(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTaskProtocol {
        return self.dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

class APIManager {
    
    static let shared = APIManager()
    private var provider: Provider?
    
    func setProvider(session: URLSessionProtocol? = nil) {
     self.provider = Provider(session: session)
    }
    
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
        provider?.requestData(url: path, method: .GET) { (data, response, error) in
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
    }
}


class Provider {
    private var session: URLSessionProtocol
    
    init(session: URLSessionProtocol? = nil) {
        self.session = session != nil ? session! : URLSession.shared
    }
    
    func requestData(url: URL, method: HTTPMethod, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        let headers = [
            "x-parse-application-id": "2416f8dd91e877f2",
            ]
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        let task = session.dataTaskTo(with: request) { (data, response, error) in
            
            completionHandler(data, response, error)
        }
        task.resume()
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case PATCH
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

class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    
    private (set) var lastURL: URL?
    
    func dataTaskTo(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        
        guard let path = Bundle.main.path(forResource: "FlickerDemo", ofType: "json") else {
            return nextDataTask
        }
        do {
            let data: Data = try Data(contentsOf: URL(fileURLWithPath: path))
            completionHandler(data, nil, nil)
            return nextDataTask
        } catch {
            fatalError("can not get List")
        }

    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() { }
}
