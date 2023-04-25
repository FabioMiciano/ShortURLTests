import Foundation
import UIKit
import SwiftUI

// PRAGMA MARK: -- PROTOCOL TO UPDATE VIEW --
protocol HomeDisplay: AnyObject {
    func addShortURLToView(model: ShortURL)
    func showErrorSnackBar(error: String)
}

final class HomeViewController: UIViewController {
    private lazy var homeView: HomeView = {
        let view = HomeView()
        view.delegate = self
        return view
    }()
    
    private let interactor: HomeInteracting
    
    init(interactor: HomeInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//PRAGMA MARK: -- LIFE CICLE --
    override func loadView() {
        super.loadView()
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//PRAGMA MARK: -- HOME VIEW DELEGATE IMPLEMENTATION --
extension HomeViewController: HomeViewDelegate {
    func pushToShort(url: String) {
        interactor.pushToShortURL(url: url)
    }
}

//PRAGMA MARK: -- HOMEDISPLAY PROTOCOL IMPLEMENTATION --
extension HomeViewController: HomeDisplay {
    func showErrorSnackBar(error: String) {
        let snackBar = Snackbar(title: error, type: .error)
        showSnackBar(snackBar)
    }
    
    func addShortURLToView(model: ShortURL) {
        homeView.apeendShortURL(model: model)
    }
}

// PRAGMA MARK: -- SWIFTUI PREVIEW ONLY DEV --
#if DEBUG
struct HomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let service = HomeService()
            let presenter = HomePresenter()
            let interactor = HomeInteractor(service: service, presenter: presenter)
            let controller = HomeViewController(interactor: interactor)
            presenter.display = controller
            let navigation = UINavigationController(rootViewController: controller)
            return navigation
        }
    }
}
#endif
