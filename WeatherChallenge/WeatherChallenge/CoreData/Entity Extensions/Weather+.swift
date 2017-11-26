//
//  Weather+.swift
//  WeatherChallenge
//
//  Created by Bearson, Matt D. on 11/26/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import Foundation
import CoreData

@objc(Weather)
public class Weather: NSManagedObject {
}

//Core Data properties
extension Weather {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather");
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var main: String?
    @NSManaged public var weatherDescription: String?
    @NSManaged public var icon: String?
    @NSManaged public var weatherGeneral: NSSet?
}

// MARK: Generated accessors for weatherGeneral
extension Weather {
    
    @objc(addWeatherGeneralObject:)
    @NSManaged public func addToWeatherGeneral(_ value: WeatherGeneral)
    
    @objc(removeWeatherGeneralObject:)
    @NSManaged public func removeFromWeatherGeneral(_ value: WeatherGeneral)
    
    @objc(addWeatherGeneral:)
    @NSManaged public func addToWeatherGeneral(_ values: NSSet)
    
    @objc(removeWeatherGeneral:)
    @NSManaged public func removeFromWeatherGeneral(_ values: NSSet)
}

//Dictionary functions
extension Weather
{
    class func initWithDictionary(dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Weather? {
        
        if let weather = NSEntityDescription.insertNewObject(forEntityName: String(describing: Weather.classForCoder()), into: context) as? Weather
        {
            weather.updateWith(dictionary: dictionary, context: context)
            return weather
        }
        
        return nil
    }
    
    func updateWith(dictionary: [String : AnyObject], context: NSManagedObjectContext)
    {
        self.id = Int64(dictionary["id"] as? Int ?? 0)
        self.main = dictionary["main"] as? String ?? ""
        self.weatherDescription = dictionary["description"] as? String ?? ""
        self.icon = dictionary["icon"] as? String ?? ""
    }
}

