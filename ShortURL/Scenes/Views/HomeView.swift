//
//  HomeView.swift
//  ShortURL
//
//  Created by Fabio Miciano on 20/04/23.
//

import Foundation
import UIKit

protocol HomeViewDelegate: AnyObject {
    func pushToShort(url: String)
}

final class HomeView: UIView {
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
    
    weak var delegate: HomeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView: ViewConfiguration {
    func createHyerarchy() {
        addSubview(urlTextField)
        addSubview(shortURLButton)
        addSubview(collection)
    }
    
    func setupConstraints() {
        
    }
    
    func setupViewConfiguration() {
        backgroundColor = .white
    }
}

@objc
private extension HomeView {
    func actionShortURL() {
        guard let urlToShort = urlTextField.text else { return }
        delegate?.pushToShort(url: urlToShort)
    }
}
