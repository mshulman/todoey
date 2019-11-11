//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Michael on 11/10/19.
//  Copyright © 2019 Michael Shulman. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {
    
    var brain = TodoModel()
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        brain.loadCategories()

    }


    // MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = brain.categories {
            return max(categories.count, 1)
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        if let categories = brain.categories {
            if categories.count == 0 {
                cell.textLabel?.text =  "No Categories Added Yet"
            } else {
                cell.textLabel?.text = brain.categories?[indexPath.row].name
            }
        } else {
            cell.textLabel?.text =  "No Categories Added Yet"
        }
        
        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = brain.categories?[indexPath.row]
            }
        }
    }
    
    
    // MARK: - Data Manipulation Methods
    
    
    
    // MARK: Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            let newCategory = TodoCategory()
            newCategory.name = textField.text!
            
            self.brain.save(category: newCategory)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    


}
