import Foundation

protocol Parser {
    func parse<T: Decodable>(model: T.Type, from data: Data) throws -> T
}

class DefatultParser: Parser {
    func parse<T: Decodable>(model: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(model, from: data)
    }
}
