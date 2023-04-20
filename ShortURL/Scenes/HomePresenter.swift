//
//  HomePresenter.swift
//  ShortURL
//
//  Created by Fabio Miciano on 20/04/23.
//

import Foundation

protocol HomePresenting {
    func addShortURLToView(model: ShortURL)
}

final class HomePresenter: HomePresenting {
    weak var display: HomeDisplay?
    
    func addShortURLToView(model: ShortURL) {
        display?.addShortURLToView(model: model)
    }
}
