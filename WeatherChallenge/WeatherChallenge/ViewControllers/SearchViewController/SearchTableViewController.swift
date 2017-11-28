//
//  SearchTableViewController.swift
//  WeatherChallenge
//
//  Created by Bearson, Matt D. on 11/26/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, SearchViewDataSourceDelegate {
    
    var datasource: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource = SearchViewModel()
        
        tableView.register(UINib(nibName: String(describing: SearchTableViewCell.classForCoder()), bundle: nil), forCellReuseIdentifier: Identifiers.kSearchCell)
        
        datasource.doCustomization()
        datasource.delegate = self
        tableView.delegate = self
        tableView.dataSource = datasource
        tableView.tableHeaderView = datasource.searchController.searchBar
        tableView.refreshControl = datasource.refreshControl
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Delegate

    func didUpdateView() {
        self.tableView.reloadData()
    }
    
    func didThrow(error: Error)
    {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        let action =  UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        
        if self.presentedViewController != nil
        {
            self.dismiss(animated: false, completion: nil)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
