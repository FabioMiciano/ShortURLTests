import Foundation
import UIKit

enum HomeFactory {
    static func make() -> UIViewController {
        let presenter = HomePresenter()
        let service = HomeService()
        let interactor = HomeInteractor(service: service, presenter: presenter)
        let controller = HomeViewController(interactor: interactor)
        presenter.display = controller
        
        return controller
    }
}

