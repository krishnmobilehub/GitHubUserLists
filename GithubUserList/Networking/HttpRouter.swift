//
//  HttpRouter.swift
//  GithubUserList
//

import Foundation
import Alamofire

enum HttpRouter: URLRequestConvertible {
    
    case getUserList(page: Int)
    case getUserDetail(userName: String)
    
    var method: String {
        switch self {
        case .getUserList,
             .getUserDetail:
            return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .getUserList:
            return "users"
        case .getUserDetail(let userName):
            return "users/\(userName)"
        }
    }
    
    var urlParameters: [String : Any]? {
        var parameters: [String: Any] = [String: Any]()
        switch self {
        case .getUserList(let page):
            parameters["since"] = page
        default:
            return nil
        }
        return parameters
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = URL(string: "\(Constants.Server.baseURL)" + "\(self.path.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? "")")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.timeoutInterval = 180
        urlRequest.cachePolicy = .useProtocolCachePolicy
        
        switch self {
        case .getUserList,
             .getUserDetail:
            return try URLEncoding.queryString.encode(urlRequest, with: urlParameters)
        }
    }
}
