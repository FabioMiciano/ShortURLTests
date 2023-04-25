import Foundation

enum APIRoute: EndPoint {
    case submit(url: String)
    
    var path: String {
        switch self {
        case .submit:
            return "api/alias"
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
        case let .submit(url):
            return ["url": url]
        }
    }
    
    var header: String? {
        switch self {
        case .submit:
            return nil
        }
    }
}
