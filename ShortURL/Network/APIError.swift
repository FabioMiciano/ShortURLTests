import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case requestFailedWith(statusCode: Int, message: String)
    case requestFailed(error: Error)
    case decodingFailed
}
