import Foundation

protocol NetworkManaging {
    func execute<T: Codable>(from endpoint: APIRoute, completion: @escaping (Result<T, APIError>) -> Void)
}

final class NetworkManager: NetworkManaging {
    private let baseURL = URL(string: "http://localhost:3000/")
    private let session: URLSession
    private let parser: Parser
    
    init(session: URLSession = URLSession.shared, parser: Parser = DefatultParser()) {
        self.session = session
        self.parser = parser
    }

// PRAGMA MARK: -- PUBLIC FUNTIONS --
    func execute<T: Codable>(from endpoint: APIRoute, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = baseURL?.appendingPathComponent(endpoint.path) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let parameters = endpoint.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        session.dataTask(with: request) {[weak self] (data, response, error) in
            if let hasError = self?.isError(error: error, response: response) {
                completion(.failure(hasError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                guard let dataParsed = try self?.parser.parse(model: T.self, from: data) else {
                    completion(.failure(.decodingFailed))
                    return
                }
                
                completion(.success(dataParsed))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }
}

// PRAGMA MARK: -- PRIVATE FUNCTIONS --
private extension NetworkManager {
    func isError(error: Error?, response: URLResponse?) -> APIError? {
        if let error = error {
            return .requestFailed(error: error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            return .requestFailedWith(statusCode: httpResponse.statusCode, message: message)
        }
        
        return nil
    }
}
