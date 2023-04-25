//
//  SnackBar.swift
//  ShortURL
//
//  Created by Fabio Miciano on 25/04/23.
//

import Foundation
import UIKit

enum SnackBarType {
    case success
    case warning
    case error
}

final class Snackbar: UIView {
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    
    init(title: String, type: SnackBarType) {
        super.init(frame: .zero)
        self.title.text = title
        setupOf(type: type)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Snackbar {
    func setupOf(type: SnackBarType) {
        switch type {
        case .success:
            self.backgroundColor = UIColor(red: 0.30, green: 0.87, blue: 0.33, alpha: 1.00)
        case .warning:
            self.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.32, alpha: 1.00)
        case .error:
            self.backgroundColor = UIColor(red: 0.87, green: 0.30, blue: 0.33, alpha: 1.00)
        }
    }
}

extension Snackbar: ViewConfiguration {
    func setupViewConfiguration() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    func createHyerarchy() {
        addSubview(title)
    }
    
    func setupConstraints() {
        title.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(57.0)
        }
    }
}
