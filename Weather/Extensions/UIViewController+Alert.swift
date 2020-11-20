//
//  UIViewController+Alert.swift
//  Weather
//
//  Created by Amar Sawant on 20/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
