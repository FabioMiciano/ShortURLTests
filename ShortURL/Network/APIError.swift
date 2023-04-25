import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case requestFailedWith(statusCode: Int, message: String)
    case requestFailed(error: Error)
    case decodingFailed
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.decodingFailed, .decodingFailed):
            return true
        case let (.requestFailedWith(statusCode1, message1), .requestFailedWith(statusCode2, message2)):
            return statusCode1 == statusCode2 && message1 == message2
        case let (.requestFailed(error1), .requestFailed(error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}
