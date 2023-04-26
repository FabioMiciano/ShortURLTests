import Foundation

protocol HomeInteracting {
    func pushToShortURL(url: String)
    func loadLocalList()
}

final class HomeInteractor: HomeInteracting {
    private let service: HomeServicing
    private let presenter: HomePresenting
    
    init(service: HomeServicing, presenter: HomePresenting) {
        self.service = service
        self.presenter = presenter
    }
    
// PRAGMA MARK: - PUBLIC FUNCTIONS -
    func pushToShortURL(url: String) {
        service.submitURLToShort(url: url) {[weak self] result in
            switch result {
            case let .success(model):
                self?.presenter.addShortURLToView(model: model)
                self?.saveLocal(model: model)
            case let .failure(error):
                self?.presenter.showError(error: error)
            }
        }
    }
    
    func loadLocalList() {
        do {
            let dataSource = try service.loadLocalDataSource()
            presenter.loadLocalList(dataSource: dataSource)
        } catch {
            presenter.showError(error: .decodingFailed)
        }
    }
}

// PRAGMA MARK: - PRIVATE FUNCTIONS -
private extension HomeInteractor {
    func saveLocal(model: ShortURL) {
        do {
            try service.saveLocalDataSource(item: model)
        } catch {
            // TODO: AQUI FARIA O USO DO FIREBASE, BUGSNAG OU ALGUMA FERRAMENTA DE TRACKS PARA INFORMAR O ERRO DO CATCH AO SALVAR A INFORMACAO LOCAL
            print("DISPARO PARA  ALGUMA FERRAMENTA DE TRACK")
        }
    }
}
