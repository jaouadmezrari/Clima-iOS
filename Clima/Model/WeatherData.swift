//
//  WeatherData.swift
//  Clima
//
//  Created by Abdeljaouad Mezrari on 30/02/2023.
//  Copyright © 2023 Abdeljaouad Mezrari. All rights reserved.
//

import Foundation

struct WeatherData: Decodable{
    let cod: Int
    let message: String?
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable{
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
}

struct Weather: Decodable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}
