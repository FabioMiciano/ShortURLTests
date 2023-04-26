import Foundation
import UIKit
import SwiftUI

// PRAGMA MARK: - SNACKBAR TYPES -
enum SnackBarType {
    case success
    case warning
    case error
}

// PRAGMA MARK: - LAYOUT CONSTANTS -
extension Snackbar.Layout {
    enum Font {
        static let numberOfLines = 2
        static let size: CGFloat = 16
    }
    
    enum Colors {
        static let success = #colorLiteral(red: 0.30, green: 0.87, blue: 0.33, alpha: 1.00)
        static let warning = #colorLiteral(red: 0.12, green: 0.12, blue: 0.32, alpha: 1.00)
        static let error = #colorLiteral(red: 0.87, green: 0.30, blue: 0.33, alpha: 1.00)
    }
    
    enum Size {
        static let cornerRadius: CGFloat = 10
        static let snackBarHeight: CGFloat = 57.0
    }
}

final class Snackbar: UIView {
    fileprivate enum Layout {}
    
// PRAGMA MARK: - LAYOUT COMPONENTS -
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = Layout.Font.numberOfLines
        label.font = UIFont.systemFont(ofSize: Layout.Font.size, weight: .bold)
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

// PRAGMA MARK: - PRIVATE FUNCTIONS -
private extension Snackbar {
    func setupOf(type: SnackBarType) {
        switch type {
        case .success:
            self.backgroundColor = Layout.Colors.success
        case .warning:
            self.backgroundColor = Layout.Colors.warning
        case .error:
            self.backgroundColor = Layout.Colors.error
        }
    }
}

// PRAGMA MARK: - BUILDING LAYOUT -
extension Snackbar: ViewConfiguration {
    func setupViewConfiguration() {
        self.layer.cornerRadius = Layout.Size.cornerRadius
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
            $0.height.equalTo(Layout.Size.snackBarHeight)
        }
    }
}

// PRAGMA MARK: - SWIFTUI PREVIEW ONLY DEV -
#if DEBUG
struct Snackbar_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = Snackbar(title: "Ops, aconteceu um erro", type: .error)
            return view
        }
    }
}
#endif
