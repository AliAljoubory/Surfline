//
//  PlacesTableViewCell.swift
//  Surfline
//
//  Created by Ali Aljoubory on 12/12/2020.
//

import UIKit

class PlacesCell: UITableViewCell {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var htmlAttributeLabel: UILabel!
    @IBOutlet var nameValueLabel: UILabel!
    @IBOutlet var ratingValueLabel: UILabel!
    @IBOutlet var openingHoursValueLabel: UILabel!
    @IBOutlet var htmlAttributeValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(place: Place, result: Results) {
        nameValueLabel.text = result.name
        
        if (result.rating == nil || result.rating == 0.0) {
            ratingValueLabel.text = "N/A"
        } else {
            ratingValueLabel.text = String(result.rating ?? 0)
        }
        
        if result.openingHours == nil {
            openingHoursValueLabel.text = "N/A"
        } else {
            if result.openingHours?.openNow == true {
                openingHoursValueLabel.text = "Open Now!"
            } else {
                openingHoursValueLabel.text = "Closed Now"
            }
        }
        
        if (result.icon != nil && result.icon != "") {
            self.downloadImage(fromURL: result.icon!)
        } else {
            logoImageView.image = Images.placeholderImage
        }
        
        if place.htmlAttributions?.isEmpty == true {
            htmlAttributeLabel.isHidden = true
            htmlAttributeValueLabel.isHidden = true
        } else {
            htmlAttributeValueLabel.text = place.htmlAttributions?.first
        }
    }
    
    private func downloadImage(fromURL url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async { self.logoImageView.image = image }
        }
    }
}
