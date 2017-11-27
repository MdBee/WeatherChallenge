//
//  CoreDataManager.swift
//  WeatherChallenge
//
//  Created by Bearson, Matt D. on 11/26/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import Foundation
import CoreData

/* Core data manager was developed to support saving Weather, WeatherGeneral, SearchList objects
 we can
 check if item exist
 remove item
 get item
 create and save item
 by using this model
 */

class CoreDataManager: NSObject
{
    private(set) var modelName: String
    private(set) var databaseName: String
    
    //Holds references to the contextes created for this manager.
    public var contextArray: [NSManagedObjectContext] = []
    
    //Returns whether or not context merges should be done synchronized. Defaults to true.
    open var synchronizedMerging: Bool = true
    
    //Manages all the instances of the CoreDataManager.
    static private(set) var managerDictionary: [String: CoreDataManager] = [:]
    
    //Gets the manager for the given model name. Assumes the database name is same as the model name.
    public class func defaultManager() -> CoreDataManager {
        return self.manager(modelName: "WeatherChallenge", databaseName: "WeatherChallenge")
        
    }
    
    //The managed object model for the given model.
    lazy public var managedObjectModel: NSManagedObjectModel = NSManagedObjectModel(contentsOf: self.modelPathURL)!
    
    //Gets the manager for the given model name. Assumes the database name is same as the model name.
    
    public class func manager(modelName: String) -> CoreDataManager {
        return self.manager(modelName: modelName, databaseName: modelName)
    }
    
    //MARK: initilization
    
    init(modelName: String, databaseName: String) {
        self.modelName = modelName
        self.databaseName = databaseName
    }
    
    //  Gets the manager for the given model and database name.
    //    If the database name already exists, will return that, regardless of model name.
    
    public class func manager(modelName: String, databaseName: String) -> CoreDataManager {
        var manager: CoreDataManager! = managerDictionary[databaseName]
        if manager == nil {
            manager = CoreDataManager(modelName: modelName, databaseName: databaseName)
            managerDictionary[databaseName] = manager
        }
        return manager
    }
    
    // MARK: - Initializers and deinitalizer
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //This is is the default managed object context for the main queue.
    
    lazy public var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    
    //Provides the model path URL for the manager's model name.
    
    open var modelPathURL: URL {
        return Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
    }
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Data.sqlite")
        var failureReason = "There was an error creating or loading the application's saved Data"
        
        
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
            
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = dict["Failed to initialize the application's saved data"]
            dict[NSLocalizedFailureReasonErrorKey] = dict[failureReason]
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.WeatherChallenge", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError)", "\(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    
    
    public func remove(context: NSManagedObjectContext) {
        self.removeObserver(context)
        if let index = self.contextArray.index(of: context) {
            self.contextArray.remove(at: index)
        }
    }
    
    //Adds a NotificationCenter observe on the given context for NSManagedObjectContextDidSave.
    
    public func addObserver(_ context: NSManagedObjectContext) {
        NotificationCenter.default.addObserver(self, selector: #selector(CoreDataManager.contextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
    }
    
    //Removes a NotificationCenter observe on the given context.
    public func removeObserver(_ context: NSManagedObjectContext) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
    }
    
    //Handles the NSManagedObjectContextDidSave notification.
    
    @objc open func contextDidSave(notification: Notification) {
        let notificationContext: NSManagedObjectContext = notification.object as! NSManagedObjectContext
        
        let contextArray = self.contextArray
        
        let mergeBlock: (NSManagedObjectContext) -> Void = { [unowned self] (context) in
            self.removeObserver(context)
            context.mergeChanges(fromContextDidSave: notification)
            self.addObserver(context)
        }
        for context in contextArray {
            if context == notificationContext {
                continue
            }
            if synchronizedMerging {
                context.performAndWait {
                    mergeBlock(context)
                }
            }
            else
            {
                context.perform {
                    mergeBlock(context)
                }
            }
        }
    }
    
    func save()
    {
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    //MARK: Existing checks
    
    func isWeatherGeneralExist(dictionary: [String: AnyObject], context: NSManagedObjectContext) -> Bool
    {
        if let id = dictionary["id"] as? Int
        {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing:WeatherGeneral.classForCoder()))
            let predicate = NSPredicate(format: "id == %@", String(id))
            fetchRequest.predicate = predicate
            let entity = NSEntityDescription.entity(forEntityName: String(describing:WeatherGeneral.classForCoder()), in: context)
            fetchRequest.entity = entity
            
            let count = try? context.count(for: fetchRequest)
            return count != 0
        }
        
        return false
    }
    
    func isWeatherExist(dictionary: [String: AnyObject], context: NSManagedObjectContext) -> Bool
    {
        if let id = dictionary["id"] as? Int
        {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing:Weather.classForCoder()))
            let predicate = NSPredicate(format: "id == %@", String(id))
            fetchRequest.predicate = predicate
            let entity = NSEntityDescription.entity(forEntityName: String(describing:Weather.classForCoder()), in: context)
            fetchRequest.entity = entity
            
            let count = try? context.count(for: fetchRequest)
            return count != 0
        }
        
        return false
    }
    
    func isSearchListExist(searchText: String, context: NSManagedObjectContext) -> Bool
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing:SearchList.classForCoder()))
        let predicate = NSPredicate(format: "searchText LIKE [cd] %@", searchText)
        fetchRequest.predicate = predicate
        let entity = NSEntityDescription.entity(forEntityName: String(describing:SearchList.classForCoder()), in: context)
        fetchRequest.entity = entity
        let count = try? context.count(for: fetchRequest)
        return count != 0
    }
    
    //MARK: Get entities
    
    func getWeatherGeneral(id: Int, context: NSManagedObjectContext) -> WeatherGeneral?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing:WeatherGeneral.classForCoder()))
        let predicate = NSPredicate(format: "id == %@", String(id))
        fetchRequest.predicate = predicate
        let entity = NSEntityDescription.entity(forEntityName: String(describing:WeatherGeneral.classForCoder()), in: context)
        fetchRequest.entity = entity
        
        do {
            if let result = try context.fetch(fetchRequest) as? [WeatherGeneral], result.count == 1
            {
                return result[0]
            }
            else
            {
                return nil
            }
            
        }
        catch {
            fatalError("Failed to fetch WeatherGeneral: \(error)")
        }
    }
    
    func getWeather(id: Int, context: NSManagedObjectContext) -> Weather?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing:Weather.classForCoder()))
        let predicate = NSPredicate(format: "id == %@", String(id))
        fetchRequest.predicate = predicate
        let entity = NSEntityDescription.entity(forEntityName: String(describing:Weather.classForCoder()), in: context)
        fetchRequest.entity = entity
        
        do {
            if let result = try context.fetch(fetchRequest) as? [Weather], result.count == 1
            {
                return result.first
            }
            else
            {
                return nil
            }
            
        }
        catch {
            fatalError("Failed to fetch WeatherGeneral: \(error)")
        }
    }
    
    func getSearchList(searchText: String, context: NSManagedObjectContext) -> SearchList?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing:SearchList.classForCoder()))
        let predicate = NSPredicate(format: "searchText LIKE[cd] %@", searchText)
        fetchRequest.predicate = predicate
        let entity = NSEntityDescription.entity(forEntityName: String(describing:SearchList.classForCoder()), in: context)
        fetchRequest.entity = entity
        
        do {
            if let result = try context.fetch(fetchRequest) as? [SearchList], result.count == 1
            {
                return result[0]
            }
            else
            {
                return nil
            }
            
        }
        catch {
            fatalError("Failed to fetch WeatherGeneral: \(error)")
        }
    }
    
    /* basic class to store all data in DB */
    
    func storeServerResponse(response: [String:AnyObject], searchText: String)
    {
        let moc = CoreDataManager.defaultManager().managedObjectContext
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = moc

        privateMOC.perform {
        
            let exist = CoreDataManager.defaultManager().isSearchListExist(searchText: searchText, context: privateMOC)
            if exist == false
            {
                let searchList = SearchList.initWithDictionary(searchText: searchText,dictionary: response, context: privateMOC)
                searchList?.searchText = searchText
                searchList?.date = NSDate()
            }
            else
            {
                let searchList = CoreDataManager.defaultManager().getSearchList(searchText: searchText, context: privateMOC)
                searchList?.updateWith(dictionary: response, context: privateMOC)
                searchList?.date = NSDate()
            }
            
            do {
                try privateMOC.save()
                privateMOC.performAndWait {
                    do {
                        try moc.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
}
