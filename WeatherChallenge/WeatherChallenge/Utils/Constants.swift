//
//  Constants.swift
//  WeatherChallenge
//
//  Created by Bearson, Matt D. on 11/26/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import Foundation

internal struct OpenWeatherMapConstants
{
    static let apiKey = "24cdbeb6ca267f6c370f3961fabff5a5"
    static let baseURL = "http://api.openweathermap.org"
}

internal struct OpenWeatherAPI
{
    static let getWeather = "/data/2.5/weather"
    static let getIcon = "/img/w/"
}

internal struct Identifiers
{
    static let kSearchCell = "kSearchCell"
    static let kSearchViewController = "kSearchViewController"
    static let kDetailsViewController = "kDetailsViewController"
    static let kIconCollectionViewCell = "kIconCollectionViewCell"
}
