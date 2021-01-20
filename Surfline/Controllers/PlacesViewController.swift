//
//  PlacesViewController.swift
//  Surfline
//
//  Created by Ali Aljoubory on 12/12/2020.
//

import UIKit

class PlacesViewController: ActivityIndicatorViewController {
    
    @IBOutlet var placesTableView: UITableView!
    
    var latitude: String?
    var longitude: String?
    
    var reuseID = "PlacesCell"
    
    var place: Place!
    var results: [Results] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Places"
        
        setUpTableView()
        getPlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setUpTableView() {
        placesTableView.delegate = self
        placesTableView.dataSource = self
        
        placesTableView.register(UINib(nibName: "PlacesCell", bundle: nil), forCellReuseIdentifier: reuseID)
        
        placesTableView.separatorColor = .label
        placesTableView.removeExcessCells()
    }
    
    func getPlaces() {
        showLoadingView()
        
        NetworkManager.shared.getPlaces(latitude: latitude, longitude: longitude) { [weak self] (result) in
            guard let self = self else {return}
            
            self.dismissLoadingView()
            
            switch result {
            
            case .success(let place):
                self.place = place
                self.results = place.results
                
                DispatchQueue.main.async {
                    if self.results.isEmpty {
                        self.placesTableView.reloadDataWithText(text: "No Places found")
                    } else {
                        self.placesTableView.reloadData()
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlert(title: "Failed to get Places", message: error.rawValue, actionTitle: "OK", actionStyle: .default)
                }
            }
        }
    }
}

extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! PlacesCell
        
        cell.selectionStyle = .none
        
        let result = results[indexPath.row]
        
        cell.set(place: place, result: result)
        
        return cell
    }
}
