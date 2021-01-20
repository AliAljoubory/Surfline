//
//  SurflineTests.swift
//  SurflineTests
//
//  Created by Ali Aljoubory on 12/12/2020.
//

import XCTest
@testable import Surfline

class SurflineTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testInvalidAPIKey() {
        let emptyAPIKey = ""
        let apiKey = PersistenceManager.retrieveAPIKey()
        
        XCTAssertNotEqual(emptyAPIKey, apiKey)
    }
    
    func testValidRegionInKm() {
        let regionInKm = MapViewController().regionInKm
        let validRegionInKm = 0.005
        
        XCTAssertEqual(regionInKm, validRegionInKm)
    }
    
    func testValidCellID() {
        let reuseID = PlacesViewController().reuseID
        let validReuseID = "PlacesCell"
        
        XCTAssertEqual(reuseID, validReuseID)
    }
}
