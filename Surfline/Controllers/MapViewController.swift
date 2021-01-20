//
//  MapViewController.swift
//  Surfline
//
//  Created by Ali Aljoubory on 14/12/2020.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var goButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    let regionInKm = 0.005
    
    var latitude: String?
    var longitude: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMap()
        setUpGoButton()
        checkLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlacesFromMap" {
            if let destinationVc = segue.destination as? PlacesViewController {
                destinationVc.latitude = latitude
                destinationVc.longitude = longitude
            }
        }
    }
    
    func setUpMap() {
        map.delegate = self
    }
    
    func setUpGoButton() {
        goButton.layer.cornerRadius = 10
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
            centreViewOnUserLocation()
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
    
    func centreViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: regionInKm, longitudeDelta: regionInKm)
            let region = MKCoordinateRegion(center: location, span: span)
            map.setRegion(region, animated: true)
        }
    }
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToPlacesFromMap", sender: self)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorisation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentAlert(title: "Could not retrieve current location", message: "Please ensure you have a current, precise location available", actionTitle: "OK", actionStyle: .default)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centre = mapView.centerCoordinate
        
        latitude = String(centre.latitude)
        longitude = String(centre.longitude)
    }
}
