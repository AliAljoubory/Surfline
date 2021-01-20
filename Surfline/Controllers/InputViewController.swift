//
//  InputViewController.swift
//  Surfline
//
//  Created by Ali Aljoubory on 12/12/2020.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {
    
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet var mapButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var latitude: String?
    var longitude: String?
    
    var isLatitudeEntered: Bool { return !latitudeTextField.text!.isEmpty }
    var isLongitudeEntered: Bool { return !longitudeTextField.text!.isEmpty }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTextFields()
        setUpButtons()
        createDismissKeyboardTapGesture()
        checkForAPIKey()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        latitudeTextField.text = ""
        longitudeTextField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlaces" {
            if let destionationVc = segue.destination as? PlacesViewController {
                destionationVc.latitude = latitude
                destionationVc.longitude = longitude
            }
        }
    }
    
    func setUpTextFields() {
        latitudeTextField.layer.cornerRadius = 6
        latitudeTextField.layer.borderWidth = 1
        latitudeTextField.layer.borderColor = UIColor.systemGray4.cgColor
        
        longitudeTextField.layer.cornerRadius = 6
        longitudeTextField.layer.borderWidth = 1
        longitudeTextField.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    func setUpButtons() {
        goButton.layer.cornerRadius = 10
        currentLocationButton.layer.cornerRadius = 10
        mapButton.layer.cornerRadius = 10
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func checkForAPIKey() {
        let apiKey = PersistenceManager.retrieveAPIKey()
        
        if apiKey == "" {
            performSegue(withIdentifier: "goToAPIKeyPersistence", sender: self)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorisation()
        } else {
            presentAlert(title: "Location Services disabled", message: "Please go to Settings, Privacy and turn on Location Services", actionTitle: "OK", actionStyle: .default)
        }
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorisation() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            presentAlert(title: "Location Services denied", message: "Location Services have been denied. Go to Settings, Privacy and turn on Location Services for Surfline", actionTitle: "OK", actionStyle: .default)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            presentAlert(title: "Location Services restricted", message: "Location Services have been restricted. Go to Settings, General, Restrictions and allow Location Services", actionTitle: "OK", actionStyle: .default)
        case .authorizedAlways:
            break
        @unknown default:
            print("New authorisation status case")
        }
    }
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        guard isLatitudeEntered else {
            presentAlert(title: "No Latitude", message: "Please enter a Latitude value", actionTitle: "OK", actionStyle: .default)
            return
        }
        
        guard isLongitudeEntered else {
            presentAlert(title: "No Longitude", message: "Please enter a Longitude value", actionTitle: "OK", actionStyle: .default)
            return
        }
        
        latitude = latitudeTextField.text
        longitude = longitudeTextField.text
        
        performSegue(withIdentifier: "goToPlaces", sender: self)
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        checkLocationServices()
    }
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToMap", sender: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAPIKeyPersistence", sender: self)
    }
}

extension InputViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        
        locationManager.stopUpdatingLocation()
        
        latitude = String(location.coordinate.latitude)
        longitude = String(location.coordinate.longitude)
        
        performSegue(withIdentifier: "goToPlaces", sender: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorisation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentAlert(title: "Could not retrieve current location", message: "Please ensure you have a current, precise location available", actionTitle: "OK", actionStyle: .default)
    }
}
