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
    private let presenter: HomePresenting
    
    init(presenter: HomePresenting) {
        self.presenter = presenter
    }
    
    func pushToShortURL(url: String) {
        
    }
}
