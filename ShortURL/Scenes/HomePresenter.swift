import Foundation

protocol HomePresenting {
    func addShortURLToView(model: ShortURL)
    func showError(error: APIError)
    func loadLocalList(dataSource: [ShortURL])
}

final class HomePresenter: HomePresenting {
    weak var display: HomeDisplay?
    
// PRAGMA MARK: -- PUBLIC FUNCTIONS --
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
    
    func loadLocalList(dataSource: [ShortURL]) {
        display?.loadLocal(dataSource: dataSource)
    }
}
