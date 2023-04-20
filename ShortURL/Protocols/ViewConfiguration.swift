import Foundation

protocol ViewConfiguration {
    func createHyerarchy()
    func setupConstraints()
    func setupViewConfiguration()
    func buildLayout()
}

extension ViewConfiguration {
    func buildLayout() {
        setupViewConfiguration()
        createHyerarchy()
        setupConstraints()
    }
}
