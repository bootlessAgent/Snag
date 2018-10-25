//
//  BuildingTableViewController.swift
//  Snag
//
//  Created by Eugene Trumpelmann on 2018/10/24.
//  Copyright © 2018 Eugene Trumpelmann. All rights reserved.
//

import UIKit
import CoreData

class BuildingTableViewController: UITableViewController {

    var selectedSite : Site? {
        didSet {
            loadData()
        }
    }
    
    var buildingArray = [Building]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
loadData()
 
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildingArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let buildCell = tableView.dequeueReusableCell(withIdentifier: "buildCell", for: indexPath)

        buildCell.textLabel?.text = buildingArray[indexPath.row].title
        buildCell.detailTextLabel?.text = buildingArray[indexPath.row].detail
        
        // Configure the cell...

        return buildCell
    }
    

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

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //   Get the new view controller using segue.destination.
        let destinationVC = segue.destination as! RoomTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedBuilding = buildingArray[indexPath.row]
        }
        
        //    Pass the selected object to the new view controller.
    }

    //MARK: - User input Actions
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var titleField = UITextField()
        var detailField = UITextField()
        
        let alert = UIAlertController(title: "Add a new building", message: "", preferredStyle: .alert)
        
        alert.addTextField { (titleAlertField) in
            titleAlertField.placeholder = "New Building Name"
            titleField = titleAlertField
        }
        
        alert.addTextField { (detailAlertField) in
            detailAlertField.placeholder = "Enter Building Details"
            detailField = detailAlertField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newBuilding = Building(context: self.context)
            
            newBuilding.title = titleField.text!
            newBuilding.detail = detailField.text!
            newBuilding.parentSite = self.selectedSite
            
            self.buildingArray.append(newBuilding)
            self.saveData()
        }
        
        
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Data Model manupulation
    func loadData(with request: NSFetchRequest<Building> = Building.fetchRequest(), predicate: NSPredicate? = nil){
        
        let sitePredicate = NSPredicate(format: "parentSite.title MATCHES %@", selectedSite!.title!)
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [sitePredicate, additionalPredicate])
        }else {
            request.predicate = sitePredicate
        }
        
        do {
            buildingArray = try context.fetch(request)
        }catch{
            print("Error loading context \(error)")
        }
        tableView.reloadData()
    }
    
    
    func saveData(){
        
        do {
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    
}
