//
//  SnackBarManager.swift
//  ShortURL
//
//  Created by Fabio Miciano on 25/04/23.
//

import Foundation
import UIKit
import SnapKit

final class SnackBarManager {
    func show(_ snackBar: Snackbar, onTopof view: UIView, duration: TimeInterval = 2, completion: (()->Void)? = nil) {
        setupLayout(snackBar, superview: view)
        displaySnackBar(snackBar, forDurarion: duration, completion: completion)
    }
    
    private func setupLayout(_ snackBar: Snackbar, superview: UIView) {
        superview.addSubview(snackBar)
        
        snackBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(superview.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
    
    private func displaySnackBar(_ snackBar: Snackbar, forDurarion displayDuration: TimeInterval, completion: (()->Void)? = nil) {
        snackBar.alpha = 0
        
        let fadeInAnimation = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
            snackBar.alpha = 1.0
        }
        
        let fadeOutAnimation = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
            snackBar.alpha = 0.0
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
