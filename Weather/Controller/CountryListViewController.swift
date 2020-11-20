//
//  CountryListViewController.swift
//  Weather
//
//  Created by Amar Sawant on 18/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import UIKit

class CountryListViewController: UITableViewController {
    var viewModel: CountryListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CountryListViewModel(dataHandler: PlaceDataInteractor())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // refresh data
        reloadView()
    }
    
    func reloadView() {
        viewModel.getAllPlaces { (places, error) in

            DispatchQueue.main.async {
                if let _ = error {
                    self.showAlert(title: "Error", message: "Problem in fetching places.\nplease try again later", action: "Ok")
                    return
                }else {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Table view delegate

extension CountryListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.setSelectedPlaceatIndex(index: indexPath.row)
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
}

// MARK: - Table view data source

extension CountryListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell.textLabel?.text = viewModel.cityNameForPlaceAtIndex(index: indexPath.row)
        cell.detailTextLabel?.text = viewModel.countryForPlaceAtIndex(index: indexPath.row)
        
        let id = viewModel.idForPlaceAtIndex(index: indexPath.row) ?? -1
        if viewModel.isPlaceSelected(id: id) {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        return cell
    }
}
