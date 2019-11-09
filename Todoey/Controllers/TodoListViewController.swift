//
//  ViewController.swift
//  Todoey
//
//  Created by Michael Shulman on 11/6/19.
//  Copyright © 2019 Michael Shulman. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
    var todoModel =  TodoModel()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadItems()
        
        if todoModel.items.count == 0 {
            let item1 = TodoItem()
            item1.title = "Find Mike"
            todoModel.items.append(item1)

            let item2 = TodoItem()
            item2.title = "Buy Eggos"
            todoModel.items.append(item2)

            let item3 = TodoItem()
            item3.title = "Destroy Demogorgon"
            todoModel.items.append(item3)
            saveItems()
        }
        
        
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = todoModel.items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
        let item = todoModel.items[indexPath.row]
        item.isDone.toggle()
        
        self.saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            let newItem = TodoItem()
            newItem.title = textField.text!
            self.todoModel.items.append(newItem)
            
            self.saveItems()
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation methods
    
    fileprivate func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(todoModel.items)
            try data.write(to: dataFilePath!)
        } catch {
            print ("Error encoding Item array, \(error)")
        }
    }

    fileprivate func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                try todoModel.items = decoder.decode([TodoItem].self, from: data)
            } catch {
                print ("Error decoding Item array, \(error)")
            }
        }
        
        
    }
    
    
}

