//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Michael Shulman on 11/6/19.
//  Copyright © 2019 Michael Shulman. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var brain = TodoModel()
    let realm = try! Realm()
    
    var selectedCategory: TodoCategory? {
        didSet {
            brain.loadItems(selectedCategory: selectedCategory!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        tableView.rowHeight = 80
        
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(brain.items?.count ?? 1, 1)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
                
        if let items = brain.items {
            if items.count == 0 {
                cell.textLabel?.text = "No Items Added"
            } else {
                let item = brain.items?[indexPath.row]
                cell.textLabel?.text = item?.title
                cell.accessoryType = item!.isDone ? .checkmark : .none
            }
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
        guard let items = brain.items else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        if items.count > 0 {
            if let item = brain.items?[indexPath.row] {
                do {
                    try realm.write {
    //                  realm.delete(item)   // to delete instead of checkmark
                        item.isDone.toggle()
                    }
                } catch {
                    print ("Error saving done status \(error)")
                }
                tableView.reloadData()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK: - Data Manipulation Methods
    
    override func deleteFromModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.brain.items?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)   // to delete instead of checkmark
                }
            } catch {
                print ("Error deleting item \(error)")
            }
        }
    }
    
//MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = TodoItem()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            
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
            brain.items = brain.items?.filteredBy(searchBar.text!)
            tableView.reloadData()
        }
    }
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            brain.loadItems(selectedCategory: selectedCategory!)
            tableView.reloadData()
            
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()    // hide keyboard and let cursor go
//            }
        }
        else {
            brain.items = brain.items?.filteredBy(searchBar.text!)
            tableView.reloadData()
        }
    }
}


