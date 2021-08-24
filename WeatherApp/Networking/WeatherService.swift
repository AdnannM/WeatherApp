//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Adnann Muratovic on 24.08.21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherService, weather: WeatherData)
    func didFailWithError(error: Error)
}

class WeatherService {
    
    typealias WeatherDataCompletionBlock = (_ data: WeatherData?) -> ()
    
    let openWeatherApi =  "http://api.openweathermap.org/data/2.5/weather?appid=a3801d58cfc7ee7e44e7b0b64ee3384c&units=metric&q="
    
    var delegate: WeatherManagerDelegate?
    
    let urlSession = URLSession.shared
    
    class func sharedWeatherServices() -> WeatherService {
        return _sharedWeatherServices
    }
    
    func getCurrentWeather(location: String, completion: @escaping WeatherDataCompletionBlock) {
        let openWeatherAPI = openWeatherApi + location.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)!
        
        print(openWeatherAPI)
        
        guard let queryURL = URL(string: openWeatherAPI) else { return }
        
        let request = URLRequest(url: queryURL)
        var weatherData = WeatherData()
        
        
        let task = urlSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data else {
                if let error = error {
                    print(error)
                }
                
                return
            }
            
            // Retrieve JSON data
            do {
        
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary

                // Parse JSON data to extract the weather condition and temperature
                if let weather = jsonResult?["weather"] as? [[String: Any]],
                    let weatherCondition = weather[0]["description"] as? String {
                    print(weatherCondition)
                    weatherData.weather = weatherCondition
                }

                if let main = jsonResult?["main"] as? [String: Any],
                    let temperature = main["temp"] as? Double {
                    weatherData.temperature = Int(temperature)
                    print("Temperature: \(weatherData.temperature)")
                }
                
                completion(weatherData)
                
            } catch {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
    }
}
let _sharedWeatherServices: WeatherService = { WeatherService() }()
