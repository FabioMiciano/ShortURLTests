//
//  HomeViewController.swift
//  ShortURL
//
//  Created by Fabio Miciano on 20/04/23.
//

import Foundation
import UIKit

protocol HomeDisplay {}

final class HomeViewController: UIViewController {
    private lazy var urlTextField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    private lazy var shortURLButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(actionShortURL), for: .touchUpInside)
        return button
    }()
    
    private lazy var collection: UICollectionView = {
        let collection = UICollectionView()
        return collection
    }()
    
    private let dataSource: [ShortURL] = []
    private let interactor: HomeInteracting
    
    init(interactor: HomeInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc
private extension HomeViewController {
    func actionShortURL() {
        guard let urlToShort = urlTextField.text else { return }
        interactor.pushToShortURL(url: urlToShort)
    }
}

extension HomeViewController: HomeDisplay {}
