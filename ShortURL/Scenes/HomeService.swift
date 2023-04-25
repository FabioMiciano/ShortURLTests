//
//  HomeService.swift
//  ShortURL
//
//  Created by Fabio Miciano on 24/04/23.
//

import Foundation

protocol HomeServicing {
    func submitURLToShort(url: String, completion: @escaping(Result<ShortURL, APIError>) -> Void)
    func saveLocalDataSource(item: ShortURL) throws
    func loadLocalDataSource() throws -> [ShortURL]
}

final class HomeService: HomeServicing {
    private let network: NetworkManaging
    private let local: LocalDataManaging
    
    init(network: NetworkManaging = NetworkManager(), local: LocalDataManaging = LocalDataManager(key: "ShortURL")) {
        self.network = network
        self.local = local
    }
    
    func submitURLToShort(url: String, completion: @escaping(Result<ShortURL, APIError>) -> Void) {
        let route = APIRoute.submit(url: url)
        network.execute(from: route) { (result: Result<ShortURL, APIError>) in
            DispatchQueue.main.async {
                switch result {
                case let .success(model):
                    completion(.success(model))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func saveLocalDataSource(item: ShortURL) throws {
        try local.save(item: item)
    }
    
    func loadLocalDataSource() throws -> [ShortURL] {
        let dataSource: [ShortURL] = try local.load()
        return dataSource
    }
}
