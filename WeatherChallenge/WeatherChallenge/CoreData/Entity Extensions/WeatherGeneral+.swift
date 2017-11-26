//
//  WeatherGeneral+.swift
//  WeatherChallenge
//
//  Created by Bearson, Matt D. on 11/26/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import Foundation
import CoreData

@objc(WeatherGeneral)
public class WeatherGeneral: NSManagedObject {
}

//Core Data properties
extension WeatherGeneral {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherGeneral> {
        return NSFetchRequest<WeatherGeneral>(entityName: "WeatherGeneral");
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var lat: Float
    @NSManaged public var lon: Float
    @NSManaged public var temp: Double
    @NSManaged public var pressure: Double
    @NSManaged public var humidity: Double
    @NSManaged public var temp_min: Double
    @NSManaged public var temp_max: Double
    @NSManaged public var dt: Int64
    @NSManaged public var windSpeed: Double
    @NSManaged public var windDeg: Double
    @NSManaged public var country: String?
    @NSManaged public var lastUpdate: NSDate?
    @NSManaged public var weather: NSSet?
    @NSManaged public var searchList: NSSet?
}

//Generated accessors for weather
extension WeatherGeneral {
    
    @objc(addWeatherObject:)
    @NSManaged public func addToWeather(_ value: Weather)
    
    @objc(removeWeatherObject:)
    @NSManaged public func removeFromWeather(_ value: Weather)
    
    @objc(addWeather:)
    @NSManaged public func addToWeather(_ values: NSSet)
    
    @objc(removeWeather:)
    @NSManaged public func removeFromWeather(_ values: NSSet)
}

//Generated accessors for searchList
extension WeatherGeneral {
    
    @objc(addSearchListObject:)
    @NSManaged public func addToSearchList(_ value: SearchList)
    
    @objc(removeSearchListObject:)
    @NSManaged public func removeFromSearchList(_ value: SearchList)
    
    @objc(addSearchList:)
    @NSManaged public func addToSearchList(_ values: NSSet)
    
    @objc(removeSearchList:)
    @NSManaged public func removeFromSearchList(_ values: NSSet)
}

//Dictionary functions
extension WeatherGeneral
{
    class func initWithDictionary(dictionary: [String : AnyObject], context: NSManagedObjectContext) -> WeatherGeneral? {
        
        if let weatherGeneral = NSEntityDescription.insertNewObject(forEntityName: String(describing: WeatherGeneral.classForCoder()), into: context) as? WeatherGeneral
        {
            weatherGeneral.updateWith(dictionary: dictionary, context: context)
            return weatherGeneral
        }
        
        return nil
    }
    
    func updateWith(dictionary: [String : AnyObject], context: NSManagedObjectContext)
    {
        self.id = Int64(dictionary["id"] as? Int ?? 0)
        self.lastUpdate = NSDate()
        
        self.name = dictionary["name"] as? String ?? ""
        self.dt =  Int64(dictionary["dt"] as? Int ?? 0)
        
        if let coordinateDict = dictionary["coord"] as? [String: AnyObject]
        {
            self.lat = coordinateDict["lat"] as? Float ?? 0
            self.lon = coordinateDict["lon"] as? Float ?? 0
        }
        
        if let mainDict = dictionary["main"] as? [String: AnyObject]
        {
            let kelvin = mainDict["temp"] as? Double ?? 0
            self.temp = Double((kelvin - 273.15) * (9/5.0) + 32)
            self.pressure = mainDict["pressure"] as? Double ?? 0
            self.humidity = mainDict["humidity"] as? Double ?? 0
            self.temp_min = mainDict["temp_min"] as? Double ?? 0
            self.temp_max = mainDict["temp_max"] as? Double ?? 0
        }
        
        if let windDict = dictionary["wind"] as? [String: AnyObject]
        {
            self.windSpeed = windDict["speed"] as? Double ?? 0
            self.windDeg = windDict["deg"] as? Double ?? 0
        }
        
        self.country = dictionary["country"] as? String ?? ""
        
        
        if let list = dictionary["weather"] as? [[String: AnyObject]]
        {
            for weatherDict in list
            {
                let exist = CoreDataManager.defaultManager().isWeatherExist(dictionary: weatherDict, context: context)
                
                if exist == true
                {
                    if let id = weatherDict["id"] as? Int,
                        let weather = CoreDataManager.defaultManager().getWeather(id: id, context: context)
                    {
                        weather.updateWith(dictionary: weatherDict, context: context)
                    }
                }
                else
                {
                    if let weather = Weather.initWithDictionary(dictionary: weatherDict, context: context)
                    {
                        self.addToWeather(weather)
                    }
                }
                
            }
        }
        
    }
}

