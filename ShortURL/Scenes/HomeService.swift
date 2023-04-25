//
//  HomeService.swift
//  ShortURL
//
//  Created by Fabio Miciano on 24/04/23.
//

import Foundation

protocol HomeServicing {
    func submitURLToShort(url: String, completion: @escaping(Result<ShortURL, APIError>) -> Void)
}

final class HomeService: HomeServicing {
    private let network: NetworkManaging
    
    init(network: NetworkManaging = NetworkManager()) {
        self.network = network
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
}
