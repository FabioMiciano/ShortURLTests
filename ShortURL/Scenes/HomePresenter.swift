//
//  HomePresenter.swift
//  ShortURL
//
//  Created by Fabio Miciano on 20/04/23.
//

import Foundation

protocol HomePresenting {
    func addShortURLToView(model: ShortURL)
    func showError(error: APIError)
}

final class HomePresenter: HomePresenting {
    weak var display: HomeDisplay?
    
    func addShortURLToView(model: ShortURL) {
        display?.addShortURLToView(model: model)
    }
    
    func showError(error: APIError) {
        switch error {
        case .requestFailedWith(let statusCode, let message):
            display?.showErrorSnackBar(error: "CODE: \(statusCode) | \(message)")
        case let .requestFailed(error):
            display?.showErrorSnackBar(error: error.localizedDescription)
        default:
            display?.showErrorSnackBar(error: "Ops, algo deu errado, tente novamente")
        }
    }
}
