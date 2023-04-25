//
//  HomeInteractor.swift
//  ShortURL
//
//  Created by Fabio Miciano on 20/04/23.
//

import Foundation

protocol HomeInteracting {
    func pushToShortURL(url: String)
}

final class HomeInteractor: HomeInteracting {
    private let service: HomeServicing
    private let presenter: HomePresenting
    
    init(service: HomeServicing, presenter: HomePresenting) {
        self.service = service
        self.presenter = presenter
    }
    
    func pushToShortURL(url: String) {
        service.submitURLToShort(url: url) {[weak self] result in
            switch result {
            case let .success(model):
                self?.presenter.addShortURLToView(model: model)
            case let .failure(error):
                self?.presenter.showError(error: error)
            }
        }
    }
}
