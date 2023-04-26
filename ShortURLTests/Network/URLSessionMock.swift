import Foundation

typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

final class URLSessionMock: URLSession {
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?

    override func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let task = URLSessionDataTaskMock()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = urlResponse
        task.expectedError = error
        return task
    }
}

final class URLSessionDataTaskMock: URLSessionDataTask {
    var completionHandler: CompletionHandler?
    var data: Data?
    var urlResponse: URLResponse?
    var expectedError: Error?
    
    override func resume() {
        DispatchQueue.main.async {
            self.completionHandler?(self.data, self.urlResponse, self.expectedError)
        }
    }
}
