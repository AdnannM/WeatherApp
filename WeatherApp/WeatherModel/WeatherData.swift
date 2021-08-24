//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Adnann Muratovic on 24.08.21.
//

import Foundation


struct WeatherData: Codable {
    var temperature: Int = 0
    var weather: String = ""
    var city: String?
    var country: String?
}
