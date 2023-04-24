//
//  APIRoute.swift
//  ShortURL
//
//  Created by Fabio Miciano on 24/04/23.
//

import Foundation

enum APIRoute: EndPoint {
    case submit(url: String)
    
    var path: String {
        switch self {
        case .submit:
            return ""
        }
    }
    
    var method: Method {
        switch self {
        case .submit:
            return .post
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .submit:
            return nil
        }
    }
    
    var header: String? {
        switch self {
        case .submit:
            return nil
        }
    }
}
