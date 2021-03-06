//
//  SnagTableViewController.swift
//  Snag
//
//  Created by Eugene Trumpelmann on 2018/10/24.
//  Copyright © 2018 Eugene Trumpelmann. All rights reserved.
//

import UIKit
import CoreData

class SnagTableViewController: UITableViewController {
    
    var selectedRoom : Room? {
        didSet {
            loadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var snagArray = [Snag]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        loadData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return snagArray.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let snagCell = tableView.dequeueReusableCell(withIdentifier: "snagCell", for: indexPath) as! SnagCell
     
        snagCell.cellTitle.text = snagArray[indexPath.row].title
        snagCell.cellDetail.text = snagArray[indexPath.row].detail
        snagCell.cellBackground.backgroundColor = UIColor.darkGray
        snagCell.cellImage.image = UIImage(named: "wallImage")
     // Configure the cell...
     
     return snagCell
     }
 
    
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //MARK: - Data manipulation
    
    func loadData(with request: NSFetchRequest<Snag> = Snag.fetchRequest(), predicate: NSPredicate? = nil){
        
        let roomPredicate = NSPredicate(format: "parentRoom.title MATCHES %@", selectedRoom!.title!)
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [roomPredicate, additionalPredicate])
        }else {
            request.predicate = roomPredicate
        }
        
        do {
            snagArray = try context.fetch(request)
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
