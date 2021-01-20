//
//  Place.swift
//  Surfline
//
//  Created by Ali Aljoubory on 14/12/2020.
//

import UIKit

struct Place: Codable {
    
    var htmlAttributions: [String]?
    let results: [Results]
}

struct Results: Codable {
    
    var icon: String?
    let name: String
    var openingHours: OpeningHours?
    var rating: Double?
}

struct OpeningHours: Codable {
    
    var openNow: Bool?
}
