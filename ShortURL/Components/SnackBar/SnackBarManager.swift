import Foundation
import UIKit
import SnapKit

// PRAGMA MARK: - LAYOUT CONSTANTS -
extension SnackBarManager.Layout {
    enum Offset {
        static let base16: CGFloat = 16
    }
    
    enum Animation {
        static let defaultDuration: TimeInterval = 0.5
        static let startAlpha: CGFloat = 0.0
        static let endAlpha: CGFloat = 1.0
    }
}

final class SnackBarManager {
    fileprivate enum Layout {}
    
// PRAGMA MARK: - PUBLIC FUNCTIONS -
    func show(_ snackBar: Snackbar, onTopof view: UIView, duration: TimeInterval = Layout.Animation.defaultDuration, completion: (() -> Void)? = nil) {
        setupLayout(snackBar, superview: view)
        displaySnackBar(snackBar, forDurarion: duration, completion: completion)
    }
}

// PRAGMA MARK: - PRIVATE FUNCTIONS -
private extension SnackBarManager {
    func setupLayout(_ snackBar: Snackbar, superview: UIView) {
        superview.addSubview(snackBar)
        
        snackBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Layout.Offset.base16)
            $0.bottom.equalTo(superview.safeAreaLayoutGuide.snp.bottom).offset(Layout.Offset.base16)
        }
    }
    
    func displaySnackBar(_ snackBar: Snackbar, forDurarion displayDuration: TimeInterval, completion: ( () -> Void)? = nil) {
        snackBar.alpha = Layout.Animation.startAlpha
        
        let fadeInAnimation = UIViewPropertyAnimator(duration: displayDuration, curve: .easeIn) {
            snackBar.alpha = Layout.Animation.endAlpha
        }
        
        let fadeOutAnimation = UIViewPropertyAnimator(duration: displayDuration, curve: .easeIn) {
            snackBar.alpha = Layout.Animation.startAlpha
        }
        
        fadeInAnimation.addCompletion { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + displayDuration) {
                fadeOutAnimation.startAnimation()
            }
        }
        
        fadeOutAnimation.addCompletion { _ in
            snackBar.removeFromSuperview()
            completion?()
        }
        
        fadeInAnimation.startAnimation()
    }
}
