//
//  SearchViewModel.swift
//  WeatherChallenge
//
//  Created by Bearson, Matt D. on 11/26/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol SearchViewDataSourceDelegate {
    func didUpdateView()
    func didThrow(error: Error)
}

// SearchViewModel populates the Search TableView

class SearchViewModel: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate, SearchTableViewCellDelegate
{
    var delegate: SearchViewDataSourceDelegate?
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var searchString: String = ""
    
    var searchController: UISearchController! = UISearchController.init(searchResultsController: nil)
    var refreshControl: UIRefreshControl! = UIRefreshControl()
    
    var searchListArray: [SearchList] = []
    
    override init() {
        super.init()
    }
    
    func searchControllerInitialization()
    {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Enter City Name"
        searchController.searchBar.autocapitalizationType = .words
    }
    
    func refreshControlInitialization() {
        refreshControl?.addTarget(self, action: #selector(self.refreshControlValueChanged), for: .valueChanged)
        refreshControl.accessibilityIdentifier = "refreshControl"
    }
    
    /* customization / init fetch result & search controller */
    func doCustomization()
    {
        initializeFetchedResultsController()
        searchControllerInitialization()
        refreshControlInitialization()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.kSearchCell, for: indexPath) as! SearchTableViewCell
        cell.delegate = self
        cell.iconImageView.image = nil
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: SearchTableViewCell, indexPath:IndexPath)
    {
        guard let selectedObject = fetchedResultsController.object(at: indexPath) as? WeatherGeneral else { fatalError("Unexpected Object in FetchedResultsController") }
        cell.weatherGeneral = selectedObject
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    //MARK: Core Data Fetch
    
    func initializeFetchedResultsController()
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherGeneral")
        
        let sortDescr = NSSortDescriptor(key: "lastUpdate", ascending: false)
        request.sortDescriptors = [sortDescr]
        
        let moc = CoreDataManager.defaultManager().managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    //MARK: Fetch Result Delegate
    
    //Updates the tableView when the data changes.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.delegate?.didUpdateView()
        }
    }
    
    //MARK: SearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text
        {
            fetchedResultsController.delegate = nil;
            fetchedResultsController = nil;
            initializeFetchedResultsController()
            
            searchString = text
            
            let moc = CoreDataManager.defaultManager().managedObjectContext
            let exist = CoreDataManager.defaultManager().isSearchListExist(searchText: searchString, context: moc)
            if exist == true
            {
                delegate?.didUpdateView()
            }
            
            let task = Backend.sharedBackend.getWeather(forCity: searchString, completionBlock: { (dictionary, response, error) in
                if let error = error
                {
                    DispatchQueue.main.async {
                        self.delegate?.didThrow(error: error)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.delegate?.didUpdateView()
                    }
                }
            })
            task.resume()
        }
        
    }
    
    //MARK: Cell delegate
    
    func didDelete(weatherGeneral: WeatherGeneral) {
        let moc  = CoreDataManager.defaultManager().managedObjectContext
        moc.delete(weatherGeneral)
    }
    
    func refreshLatestResult() {
        initializeFetchedResultsController()
        if let latest = fetchedResultsController.fetchedObjects?.first as? WeatherGeneral {
            let task = Backend.sharedBackend.getWeather(forCity: latest.name ?? "", completionBlock: { (dictionary, response, error) in
                if let error = error
                {
                    DispatchQueue.main.async {
                        self.delegate?.didThrow(error: error)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.delegate?.didUpdateView()
                    }
                }
            })
            task.resume()
        }
    }
    
    
    //MARK: Refresh Control target
    
    @objc func refreshControlValueChanged(refresh:UIRefreshControl) {
        refreshLatestResult()
        refreshControl.endRefreshing()
    }
}
