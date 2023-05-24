//
//  UIvVewController + extensions.swift
//  CryptoRate
//
//  Created by Андрей Важенов on 24.05.2023.
//

import UIKit

extension UIViewController {
    func showToast(message: String, interval: Double, complition: (() -> Void)? = nil) {
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .gray
        alert.view.alpha = 1
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval) {
            alert.dismiss(animated: true, completion: nil)
            complition?()
        }
    }
}
