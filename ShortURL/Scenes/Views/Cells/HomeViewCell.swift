//
//  HomeViewCell.swift
//  ShortURL
//
//  Created by Fabio Miciano on 24/04/23.
//

import Foundation
import UIKit
import SnapKit
import SwiftUI

final class HomeViewCell: UICollectionViewCell {
    static let identifier = String(describing: HomeViewCell.self)
    
    private lazy var shortURL: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var originURL: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
    func setup(shortURL: String, originURL: String) {
        self.shortURL.text = shortURL
        self.originURL.text = originURL
        buildLayout()
    }
}

extension HomeViewCell: ViewConfiguration {
    func createHyerarchy() {
        addSubview(shortURL)
        addSubview(originURL)
    }
    
    func setupConstraints() {
        shortURL.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        originURL.snp.makeConstraints {
            $0.top.equalTo(shortURL.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview().inset(8)
        }
    }
    
    func setupViewConfiguration() {
        backgroundColor = .white
        layer.cornerRadius = 5
    }
}

#if DEBUG
struct HomeViewCell_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = HomeViewCell()
            view.setup(shortURL: "SHORT URL", originURL: "ORIGINAL URL")
            return view
        }
    }
}
#endif
