//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Adnann Muratovic on 24.08.21.
//

import Foundation


public struct WeatherData: Codable {
    public var temperature: Int = 0
    public var weather: String = ""
    
    public init() {}
    
    public init(temperature: Int, weather: String) {
        self.temperature = temperature
        self.weather = weather
    }
}
