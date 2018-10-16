//
//  ViewController.swift
//  Snag
//
//  Created by Eugene Trumpelmann on 2018/10/16.
//  Copyright © 2018 Eugene Trumpelmann. All rights reserved.
//

import UIKit
import CoreData

class MainMenuController: UITableViewController {

    //Create Array for TableView Cell Display
    var snagArray = [SnagList]()
    
    
    //Create Snaglist context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadData()
    }


    //MARK: - TableView Setup & Cell Blueprint
    
    //Set number of Sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snagArray.count
    }
    
    
    
    
    //Create Cell to display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "snagCellDefault", for: indexPath)
        
        let snag = snagArray[indexPath.row]
        
        cell.textLabel?.text = snag.title
        cell.detailTextLabel?.text = snag.detail
        
        return cell
    }
    
    
    
    //MARK: - ADD button functionality - ALERT SHOULD BE CHANGED TO MODAL VIEW
    @IBAction func addNewSnag(_ sender: UIBarButtonItem) {
        
        //create variables
        
        var titleField = UITextField()
        var detailField = UITextField()
        
        //create alert
        let alert = UIAlertController(title: "Add a new Snag", message: "", preferredStyle: .alert)
        
        //Add textfield to alert
        alert.addTextField { (titleFieldText) in
            titleFieldText.placeholder = "Enter Snag Title"
            titleField = titleFieldText
        }
        alert.addTextField { (detailFieldText) in
            detailFieldText.placeholder = "Enter some detail here"
            detailField = detailFieldText
        }
        
        //create alert action
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newSnag = SnagList(context: self.context)
            
            newSnag.title = titleField.text
            newSnag.detail = detailField.text
            self.snagArray.append(newSnag)
            
            self.saveData()
        }
        //add action to new alert
        alert.addAction(action)
        //present alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Create Database save and load functions
    
    func saveData (){
        
        do{
            try context.save()
            
        }catch{
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData (){
        
        let request : NSFetchRequest<SnagList> = SnagList.fetchRequest()
        
        do {
            snagArray = try context.fetch(request)
        }catch{
            print("Error loading context: \(error)")
        }
        
    }
    
    
}

