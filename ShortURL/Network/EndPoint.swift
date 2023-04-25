import Foundation

protocol EndPoint {
    var path: String { get }
    var method: Method { get }
    var parameters: [String: Any]? { get }
    var header: String? { get }
}
