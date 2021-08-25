//
//  ViewController.swift
//  WeatherApp
//
//  Created by Adnann Muratovic on 24.08.21.
//

import UIKit
import CoreLocation
import WeatherInfoKit

class WeatherViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var city = "Sarajevo"
    var country = "Bosnia and Herzegovina"

    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityName.text = ""
        countryName.text = ""
        displayCurrentWeather()
    }
    
    func displayCurrentWeather() {
        
        // Update Location
        cityName.text = city
        countryName.text = country
        
        // Invoke weather service to get weather data
        WeatherService.sharedWeatherServices().getCurrentWeather(location: city, completion: {(data) -> () in
            OperationQueue.main.addOperation { () -> Void in
                if let weatherData = data {
                    self.weatherLabel.text = weatherData.weather.capitalized
                    self.tempLabel.text = String(format: "%d", weatherData.temperature) + "\u{00B0} C"
                }
            }
        })
    }
    
    // MARK: - Segue
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
    }

    @IBAction func updateWeather(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! LocationTableViewController
        
        city = sourceViewController.selectedCity
        country = sourceViewController.selectedCountry
        
        displayCurrentWeather()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showCity" {
            let destinationController = segue.destination as! UINavigationController
            let locationTableViewController = destinationController.viewControllers[0] as! LocationTableViewController
            locationTableViewController.selectedLocation = "\(city), \(country)"
        }
    }
}

