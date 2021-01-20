//
//  APIPersistenceViewController.swift
//  Surfline
//
//  Created by Ali Aljoubory on 13/12/2020.
//

import UIKit

class APIPersistenceViewController: UIViewController {
    
    @IBOutlet var apiKeyTextField: UITextField!
    @IBOutlet var saveKeyButton: UIButton!
    
    var isAPIKeyEntered: Bool { return !apiKeyTextField.text!.isEmpty }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpButton()
        createDismissKeyboardTapGesture()
    }
    
    func setUpButton() {
        saveKeyButton.layer.cornerRadius = 10
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func saveKeyButtonPressed(_ sender: UIButton) {
        guard isAPIKeyEntered else {
            presentAlert(title: "No API Key", message: "Please enter an API Key value", actionTitle: "OK", actionStyle: .default)
            return
        }
        
        PersistenceManager.save(apiKey: apiKeyTextField.text, for: self)
    }
}
