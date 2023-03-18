//
//  WeatherManager.swift
//  Clima
//
//  Created by Abdeljaouad Mezrari on 30/02/2023.
//  Copyright © 2023 Abdeljaouad Mezrari. All rights reserved.
//

import Foundation
protocol WeatherManagerDelegate{
    func weatherDidUpdate(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailedWithError (_ weatherManager: WeatherManager, _ error: Error)
}
struct WeatherManager{
    let API_URL = "https://api.openweathermap.org/data/2.5/weather?"
    let API_KEY = ""
    var units   = "metric"
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(city: String){
        let stringUrl = "\(API_URL)appid=\(API_KEY)&units=\(units)&q=\(city)"
        performRequest(with: stringUrl)
    }
    
    func fetchWeather(lat: String, long: String){
        let stringUrl = "\(API_URL)appid=\(API_KEY)&units=\(units)&lat=\(lat)&lon=\(long)"
        print(stringUrl)
        performRequest(with: stringUrl)
    }
    
    func performRequest(with stringUrl: String){
        if let url = URL(string: stringUrl){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: {(data, urlResponse, error) in
                if error != nil {
                    self.delegate?.didFailedWithError(self, error!)
                    return
                }
                
                if let safeData = data{
                    if let parsedData = parseJson(safeData){
                        self.delegate?.weatherDidUpdate(self, parsedData)
                    }
                }
            })
            task.resume()
        }
    }
    
    func parseJson(_ data: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let conditionId = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            let weather = WeatherModel(conditionId: conditionId, cityName: cityName, temperature: temperature)
            
            return weather
        } catch {
            self.delegate?.didFailedWithError(self, error)
        }
        return nil
    }
}
