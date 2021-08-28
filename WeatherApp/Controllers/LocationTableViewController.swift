//
//  LocationTableViewController.swift
//  WeatherApp
//
//  Created by Adnann Muratovic on 24.08.21.
//

import UIKit
import CoreLocation
import WidgetKit

class LocationTableViewController: UITableViewController {
    
    var defaults = UserDefaults(suiteName: "group.com.adnannmuratovic.weatherapp")
    
//    let savedData = SaveData()
    
    var locations = [String]()
    

        var selectedLocation = "" {
            didSet {
                let locations = selectedLocation.split { $0 == "," }.map { String($0) }
                
                selectedCity = locations[0]
                selectedCountry = locations[1].trimmingCharacters(in: .whitespacesAndNewlines)
                
            }
        }
        
        private(set) var selectedCity = ""
        private(set) var selectedCountry = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()
            loadData()
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

        // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            // Return the number of sections
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Return the number of rows
            return locations.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            // Configure the cell...
            cell.textLabel?.text = locations[indexPath.row]
            cell.accessoryType = (locations[indexPath.row] == selectedLocation) ? .checkmark : .none
            saveData()
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            if let location = cell?.textLabel?.text {
                selectedLocation = location
                
                defaults?.setValue(selectedCity, forKey: "city")
            }
            
            WidgetCenter.shared.reloadAllTimelines()
            
            tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locations.remove(at: 0)
            tableView.reloadData()
            
        }
    }
    
    // MARK: Action
    @IBAction func addCity(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        let submitAcion = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac]_ in
            guard let takeCity = ac?.textFields?[0].text else { return }
            self?.submit(takeCity)
        }
        
        ac.addAction(submitAcion)
        present(ac, animated: true)
    }
    
    private func submit(_ action: String) {
        locations.insert(action, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - SaveCity UserDefaults
extension LocationTableViewController {
    private func loadData() {
        let defaults = UserDefaults.standard
        if let saveCity = defaults.object(forKey: "city") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                locations = try jsonDecoder.decode([String].self, from: saveCity)
            }
            
            catch {
                print("Failed to load Items")
            }
        }
        
    }
    
    private func saveData() {
        let jsonEncoder = JSONEncoder()
        if let saveData = try? jsonEncoder.encode(locations) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "city")
        } else {
            print("Failed to Save City")
        }
    }
}
