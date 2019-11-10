//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Michael on 11/10/19.
//  Copyright © 2019 Michael Shulman. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    
    var brain = TodoModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        brain.loadCategories()

    }


    // MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brain.categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = brain.categories[indexPath.row]
        cell.textLabel?.text = category.name
        
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
                destinationVC.selectedCategory = brain.categories[indexPath.row]
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
            
            let newCategory = TodoCategory(context: self.brain.context)
            newCategory.name = textField.text!
            self.brain.categories.append(newCategory)
            
            self.brain.saveData()
            
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
