//
//  WeatherChallengeTests.swift
//  WeatherChallengeTests
//
//  Created by Bearson, Matt D. on 11/26/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import XCTest
@testable import WeatherChallenge
import CoreData

/* Unfortunatley i didn't have enought time to cover whole project with Unit Tests, i can do that if receive approve for that (additional time) */

class WeatherChallengeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateWeatherGeneral()
    {
        let moc = CoreDataManager.defaultManager().managedObjectContext
        let weatherGeneral = NSEntityDescription.insertNewObject(forEntityName: String(describing: WeatherGeneral.classForCoder()), into: moc)
        XCTAssertNotNil(weatherGeneral)
    }
    
    func testCreateSearchList()
    {
        let moc = CoreDataManager.defaultManager().managedObjectContext
        let weatherGeneral = NSEntityDescription.insertNewObject(forEntityName: String(describing: SearchList.classForCoder()), into: moc)
        XCTAssertNotNil(weatherGeneral)
    }
    
    func testCreateWeather()
    {
        let moc = CoreDataManager.defaultManager().managedObjectContext
        let weatherGeneral = NSEntityDescription.insertNewObject(forEntityName: String(describing: Weather.classForCoder()), into: moc)
        XCTAssertNotNil(weatherGeneral)
    }
    
    func testSaveToWeather()
    {
        let moc = CoreDataManager.defaultManager().managedObjectContext
        let weather = NSEntityDescription.insertNewObject(forEntityName: String(describing: Weather.classForCoder()), into: moc) as? Weather
        weather?.id = 1
        weather?.icon = "100"
        weather?.main = "main"
        weather?.weatherDescription = "weatherDescription"
        
        do
        {
            try moc.save()
        }
        catch
        {
            XCTFail("Failure to save context: \(error)")
        }
        
    }
    
    func testSaveToSearchList()
    {
        let moc = CoreDataManager.defaultManager().managedObjectContext
        let searchList = NSEntityDescription.insertNewObject(forEntityName: String(describing: SearchList.classForCoder()), into: moc) as? SearchList
        
        searchList?.searchText = "Paris"
        searchList?.date = NSDate()
        
        do
        {
            try moc.save()
        }
        catch
        {
            XCTFail("Failure to save context: \(error)")
        }
    }
    
    func testSaveToWeatherGeneral()
    {
        let moc = CoreDataManager.defaultManager().managedObjectContext
        let weatherGeneral = NSEntityDescription.insertNewObject(forEntityName: String(describing: WeatherGeneral.classForCoder()), into: moc) as? WeatherGeneral
        
        weatherGeneral?.id = 2
        weatherGeneral?.country = "GB"
        weatherGeneral?.name = "some name"
        weatherGeneral?.lastUpdate = NSDate()
        
        do
        {
            try moc.save()
        }
        catch
        {
            XCTFail("Failure to save context: \(error)")
        }
    }
}
