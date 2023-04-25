import Foundation
import UIKit
import SwiftUI
import SnapKit

// PRAGMA MARK: -- HOME VIEW DELEGATE --
protocol HomeViewDelegate: AnyObject {
    func pushToShort(url: String)
}

// PRAGMA MARK: -- LAYOUT CONSTANTS --
extension HomeView.Layout {
    enum Offset {
        static let base08: CGFloat = 8
        static let base16: CGFloat = 16
    }
    
    enum Size {
        static let base52: CGFloat = 52
    }
}

final class HomeView: UIView {
    fileprivate enum Layout {}
    
// PRAGMA MARK: -- LAYOUT COMPONENTS --
    private lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "http://www.google.com"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var shortURLButton: UIButton = {
        let button = UIButton()
        button.setTitle("Short", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.addTarget(self, action: #selector(actionShortURL), for: .touchUpInside)
        return button
    }()
    
    private lazy var collection: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.identifier)
        return collectionView
    }()
    
    private var dataSource: [ShortURL] = []
    
    weak var delegate: HomeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// PRAGMA MARK: -- PUBLIC FUNCS --
    func apeendShortURL(model: ShortURL) {
        dataSource.append(model)
        collection.reloadData()
    }
    
    func loadList(dataSource: [ShortURL]) {
        self.dataSource = dataSource
        collection.reloadData()
    }
}

// PRAGMA MARK: -- BUILDING LAYOUT --
extension HomeView: ViewConfiguration {
    func createHyerarchy() {
        addSubview(urlTextField)
        addSubview(shortURLButton)
        addSubview(collection)
    }
    
    func setupConstraints() {
        urlTextField.snp.makeConstraints {
            $0.top.leading.equalTo(self.safeAreaLayoutGuide).offset(Layout.Offset.base16)
            $0.height.equalTo(Layout.Size.base52)
        }
        
        shortURLButton.snp.makeConstraints {
            $0.centerY.equalTo(urlTextField.snp.centerY)
            $0.leading.equalTo(urlTextField.snp.trailing).offset(Layout.Offset.base08)
            $0.trailing.equalToSuperview().offset(-Layout.Offset.base16)
            $0.size.equalTo(Layout.Size.base52)
        }
        
        collection.snp.makeConstraints {
            $0.top.equalTo(urlTextField.snp.bottom).offset(Layout.Offset.base08)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupViewConfiguration() {
        backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
    }
}

// PRAGMA MARK: -- BUTTON ACTIONS --
@objc
private extension HomeView {
    func actionShortURL() {
        guard let urlToShort = urlTextField.text else { return }
        delegate?.pushToShort(url: urlToShort)
    }
}

// PRAGMA MARK: -- PRIVATE FUNCS --
private extension HomeView {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let itemInsets = NSDirectionalEdgeInsets(
            top: Layout.Offset.base08,
            leading: Layout.Offset.base08,
            bottom: 0,
            trailing: Layout.Offset.base08
        )
        item.contentInsets = itemInsets
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(68))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// PRAGMA MARK: -- COLLECTION VIEW DATASOURCE --
extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCell.identifier, for: indexPath) as? HomeViewCell else { return UICollectionViewCell() }
        let model = dataSource[indexPath.row]
        cell.setup(shortURL: model.link.short, originURL: model.link.original)
        return cell
    }
}

// PRAGMA MARK: -- SWIFTUI PREVIEW ONLY DEV --
#if DEBUG
struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = HomeView()
            return view
        }
    }
}
#endif
