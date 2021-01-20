//
//  UITableView.swift
//  Surfline
//
//  Created by Ali Aljoubory on 12/12/2020.
//

import UIKit

extension UITableView {
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
    func reloadDataWithText(text: String) {
        self.reloadData()
        
        if self.visibleCells.isEmpty {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            
            label.text = text
            label.textColor = .label
            label.textAlignment = .center
            
            self.backgroundView = label
            self.separatorStyle = .none
        }
    }
}
