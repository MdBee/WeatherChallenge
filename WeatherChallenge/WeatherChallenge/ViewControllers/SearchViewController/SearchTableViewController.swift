//
//  SearchTableViewController.swift
//  WeatherChallenge
//
//  Created by Bearson, Matt D. on 11/26/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, SearchViewDataSourceDelegate {
    
    var datasource: SearchViewDataSource!
    
//    required init?(coder aDecoder: NSCoder) {
//        datasource = SearchViewDataSource()
//        super.init(coder: aDecoder)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource = SearchViewDataSource()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: String(describing: SearchTableViewCell.classForCoder()), bundle: nil), forCellReuseIdentifier: Identifiers.kSearchCell)
        
        datasource.doCustomization()
        datasource.delegate = self
        tableView.delegate = self
        tableView.dataSource = datasource
        tableView.tableHeaderView = datasource.searchController.searchBar        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Weather"
//    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "kSearchCell", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: Delegate
    /* updating view */
    func didUpdateView() {
        self.tableView.reloadData()
    }
    
    /* showing error if server send it */
    func didShow(error: Error)
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
