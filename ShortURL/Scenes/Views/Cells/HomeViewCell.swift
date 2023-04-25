import Foundation
import UIKit
import SnapKit
import SwiftUI

// PRAGMA MARK: -- LAYOUT CONSTANTS --
extension HomeViewCell.Layout {
    enum Font {
        static let title: CGFloat = 16
        static let subTitle: CGFloat = 14
    }
    
    enum Offset {
        static let base08: CGFloat = 8
    }
    
    enum Size {
        static let cornerRadius: CGFloat = 5
    }
}

final class HomeViewCell: UICollectionViewCell {
    fileprivate enum Layout {}
    
    static let identifier = String(describing: HomeViewCell.self)
    
// PRAGMA MARK: -- LAYOUT COMPONENTS --
    private lazy var shortURL: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Layout.Font.title, weight: .semibold)
        return label
    }()
    
    private lazy var originURL: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Layout.Font.subTitle, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
// PRAGMA MARK: -- PUBLIC FUNCS --
    func setup(shortURL: String, originURL: String) {
        self.shortURL.text = shortURL
        self.originURL.text = originURL
        buildLayout()
    }
}

// PRAGMA MARK: -- BUILDING LAYOUT --
extension HomeViewCell: ViewConfiguration {
    func createHyerarchy() {
        addSubview(shortURL)
        addSubview(originURL)
    }
    
    func setupConstraints() {
        shortURL.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Layout.Offset.base08)
            $0.leading.trailing.equalToSuperview().inset(Layout.Offset.base08)
        }
        
        originURL.snp.makeConstraints {
            $0.top.equalTo(shortURL.snp.bottom).offset(Layout.Offset.base08)
            $0.leading.trailing.bottom.equalToSuperview().inset(Layout.Offset.base08)
        }
    }
    
    func setupViewConfiguration() {
        backgroundColor = .white
        layer.cornerRadius = Layout.Size.cornerRadius
    }
}

// PRAGMA MARK: -- SWIFTUI PREVIEW ONLY DEV --
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
