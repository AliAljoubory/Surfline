//
//  UIViewController.swift
//  Surfline
//
//  Created by Ali Aljoubory on 12/12/2020.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
        present(ac, animated: true)
    }
    
    func presentAlertWithHandlerToDismissView(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style, viewController: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: { (action) in
            viewController.dismiss(animated: true, completion: nil)
        }))
        present(ac, animated: true)
    }
}
