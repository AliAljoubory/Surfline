//
//  PersistenceManager.swift
//  Surfline
//
//  Created by Ali Aljoubory on 13/12/2020.
//

import UIKit

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys { static let apiKey = "apiKey" }
    
    static func save(apiKey: String?, for viewController: UIViewController) {
        defaults.set(apiKey, forKey: Keys.apiKey)
        viewController.presentAlertWithHandlerToDismissView(title: "API Key saved", message: "Your API Key \(apiKey ?? "") has been saved locally", actionTitle: "OK", actionStyle: .default, viewController: viewController)
    }
    
    static func retrieveAPIKey() -> String {
        return defaults.object(forKey: Keys.apiKey) as? String ?? ""
    }
}
