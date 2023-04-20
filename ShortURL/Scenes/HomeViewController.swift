//
//  HomeViewController.swift
//  ShortURL
//
//  Created by Fabio Miciano on 20/04/23.
//

import Foundation
import UIKit

protocol HomeDisplay: AnyObject {
    func addShortURLToView(model: ShortURL)
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
    
    override func loadView() {
        super.loadView()
        view = homeView
    }
}

extension HomeViewController: HomeViewDelegate {
    func pushToShort(url: String) {
        interactor.pushToShortURL(url: url)
    }
}

extension HomeViewController: HomeDisplay {
    func addShortURLToView(model: ShortURL) {
        
    }
}
