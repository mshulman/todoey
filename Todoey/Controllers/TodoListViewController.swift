//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Michael Shulman on 11/6/19.
//  Copyright © 2019 Michael Shulman. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var brain = TodoModel()
    
    var selectedCategory: TodoCategory? {
        didSet {
            brain.loadItems(category: selectedCategory!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brain.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = brain.items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
        let item = brain.items[indexPath.row]
        item.isDone.toggle()
        
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        context.delete(brain.items[indexPath.row])
//        brain.items.remove(at: indexPath.row)       // delete instead of marking as done
        
        brain.saveData()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

//MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            let newItem = TodoItem(context: self.brain.context)
            newItem.title = textField.text!
            newItem.isDone = false
            newItem.parentCategory = self.selectedCategory
            self.brain.items.append(newItem)
            
            self.brain.saveData()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text != "" {
            brain.loadItems(with: createFetchRequest(contains: searchBar.text!), category: selectedCategory!)
        } else {
            brain.loadItems(category: selectedCategory!)
        }
        tableView.reloadData()
    }
    
    func createFetchRequest(contains string: String) -> NSFetchRequest<TodoItem> {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", string)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            brain.loadItems(category: selectedCategory!)
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()    // hide keyboard and let cursor go
            }
        } else {
            brain.loadItems(with: createFetchRequest(contains: searchText), category: selectedCategory!)
            tableView.reloadData()

        }
    }
}
