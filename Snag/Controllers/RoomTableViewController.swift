//
//  RoomTableViewController.swift
//  Snag
//
//  Created by Eugene Trumpelmann on 2018/10/24.
//  Copyright © 2018 Eugene Trumpelmann. All rights reserved.
//

import UIKit
import CoreData

class RoomTableViewController: UITableViewController {
    
    var selectedBuilding : Building? {
        didSet {
            loadData()
        }
    }
    
    var roomArray = [Room]()
    
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
        return roomArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let roomCell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
        
        roomCell.textLabel?.text = roomArray[indexPath.row].title
        roomCell.detailTextLabel?.text = roomArray[indexPath.row].detail
        
        // Configure the cell...
        
        return roomCell
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
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destination.
    //        let destinationVC = segue.destination as! RoomTableViewController
    //
    //        destinationVC
    //
    //
    //        // Pass the selected object to the new view controller.
    //    }
    //
    
    //MARK: - User input Actions
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var titleField = UITextField()
        var detailField = UITextField()
        
        let alert = UIAlertController(title: "Add a new room", message: "", preferredStyle: .alert)
        
        alert.addTextField { (titleAlertField) in
            titleAlertField.placeholder = "New Room Name"
            titleField = titleAlertField
        }
        
        alert.addTextField { (detailAlertField) in
            detailAlertField.placeholder = "Enter Room Details"
            detailField = detailAlertField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newRoom = Room(context: self.context)
            
            newRoom.title = titleField.text!
            newRoom.detail = detailField.text!
            newRoom.parentBuilding = self.selectedBuilding
            self.roomArray.append(newRoom)
            self.saveData()
        }
        
        
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Data Model manupulation
    
//    func loadData(){
//
//        let request : NSFetchRequest<Room> = Room.fetchRequest()
//
//        do {
//            roomArray = try context.fetch(request)
//        }catch{
//            print("Error loading context \(error)")
//        }
//        tableView.reloadData()    }
    
        func loadData(with request: NSFetchRequest<Room> = Room.fetchRequest(), predicate: NSPredicate? = nil){
    
            let buildingPredicate = NSPredicate(format: "parentBuilding.title MATCHES %@", selectedBuilding!.title!)
    
    
            if let additionalPredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [buildingPredicate, additionalPredicate])
            }else {
                request.predicate = buildingPredicate
            }
    
            do {
                roomArray = try context.fetch(request)
            }catch{
                print("Error loading context \(error)")
            }
            tableView.reloadData()
        }
    
    
    func saveData(){
        
        do {
            try self.context.save()
        }catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    
}
