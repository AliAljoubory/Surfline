//
//  SurflineError.swift
//  Surfline
//
//  Created by Ali Aljoubory on 14/12/2020.
//

import UIKit

enum SurflineError: String, Error {
    
    case invalidRequest = "Invalid URL request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data recieved from the server is invalid. Please try again."
    case noAPIKey = "No API Key has been saved. Please go to Settings and enter an API Key."
}
