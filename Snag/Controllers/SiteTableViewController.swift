//
//  SiteTableViewController.swift
//  Snag
//
//  Created by Eugene Trumpelmann on 2018/10/24.
//  Copyright © 2018 Eugene Trumpelmann. All rights reserved.
//

import UIKit
import CoreData

class SiteTableViewController: UITableViewController {
    
    var siteArray = [Site]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.separatorStyle = .none
        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //   self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        
        var titleField = UITextField()
        var detailField = UITextField()
        
        let alert = UIAlertController(title: "Add a new site", message: "", preferredStyle: .alert)
        
        alert.addTextField { (titleAlertField) in
            titleAlertField.placeholder = "New Site Name"
            titleField = titleAlertField
        }
        
        alert.addTextField { (detailAlertField) in
            detailAlertField.placeholder = "Enter Site Details"
            detailField = detailAlertField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newSite = Site(context: self.context)
            
            newSite.title = titleField.text!
            newSite.detail = detailField.text!
            
            self.siteArray.append(newSite)
            self.saveData()
        }
        
        
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return siteArray.count
        
        //return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "siteCell", for: indexPath)
        
        cell.textLabel?.text = siteArray[indexPath.row].title
        cell.detailTextLabel?.text = siteArray[indexPath.row].detail
        
        // Configure the cell...
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let alert = UIAlertController(title: "Are you sure you want to delete?", message: "This will erase ALL data from site: \(siteArray[indexPath.row].title ?? "")", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "DELETE", style: .destructive) { (action) in
                
                self.context.delete(self.siteArray[indexPath.row])
                self.siteArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true) {
                self.saveData()
            }
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
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
    
    //MARK: - TableView Delegates
    
    
    
    
    
    
    
    //MARK: - Navigation
    
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //   Get the new view controller using segue.destination.
        let destinationVC = segue.destination as! BuildingTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedSite = siteArray[indexPath.row]
        }
        
        //    Pass the selected object to the new view controller.
    }
    
    
    //MARK: - Data Model Manipulation
    
    func loadData(with request:NSFetchRequest<Site> = Site.fetchRequest()){
        do {
            siteArray = try context.fetch(request)
        }catch {
            print("Error loading data with: \(error)")
        }
        tableView.reloadData()
    }
    
    func saveData() {
        do{
            try context.save()
        }catch{
            print("Error saving data with: \(error)")
        }
        tableView.reloadData()
    }
    
    
}
