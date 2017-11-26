//
//  SearchList+.swift
//  WeatherChallenge
//
//  Created by Bearson, Matt D. on 11/26/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import Foundation
import CoreData

@objc(SearchList)
public class SearchList: NSManagedObject {
}

//Core Data properties
extension SearchList {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchList> {
        return NSFetchRequest<SearchList>(entityName: "SearchList");
    }
    
    @NSManaged public var searchText: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var list: NSSet?
    
}

//Generated accessors for list
extension SearchList {
    
    @objc(addListObject:)
    @NSManaged public func addToList(_ value: WeatherGeneral)
    
    @objc(removeListObject:)
    @NSManaged public func removeFromList(_ value: WeatherGeneral)
    
    @objc(addList:)
    @NSManaged public func addToList(_ values: NSSet)
    
    @objc(removeList:)
    @NSManaged public func removeFromList(_ values: NSSet)
    
}


//Dictionary Functions
extension SearchList
{
    class func initWithDictionary(searchText: String, dictionary: [String : AnyObject], context: NSManagedObjectContext) -> SearchList? {
        
        if let searchList = NSEntityDescription.insertNewObject(forEntityName: String(describing: SearchList.classForCoder()), into: context) as? SearchList
        {
            searchList.searchText = searchText
            searchList.updateWith(dictionary: dictionary, context: context)
            return searchList
        }
        
        return nil
    }
    
    func updateWith(dictionary: [String : AnyObject], context: NSManagedObjectContext)
    {
        let exist = CoreDataManager.defaultManager().isWeatherGeneralExist(dictionary: dictionary, context: context)
        
        if exist == true
        {
            if let id = dictionary["id"] as? Int,
                let weatherGeneral = CoreDataManager.defaultManager().getWeatherGeneral(id: id, context: context)
            {
                weatherGeneral.updateWith(dictionary: dictionary, context: context)
            }
        }
        else
        {
            if let weatherGeneral = WeatherGeneral.initWithDictionary(dictionary: dictionary, context: context)
            {
                self.addToList(weatherGeneral)
            }
        }
    }
}
