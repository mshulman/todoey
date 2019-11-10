//
//  TodoModel.swift
//  Todoey
//
//  Created by Michael Shulman on 11/9/19.
//  Copyright © 2019 Michael Shulman. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TodoModel  {
    var items: [TodoItem] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveItems() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
    
    func loadItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()) {
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }

//        if self.items.count == 0 {
//            loadSampleData()
//        }
    }
    
    func loadSampleData(){
        let item1 = TodoItem(context: self.context)
        item1.title = "Find Mike"
        item1.isDone = false
        self.items.append(item1)
        
        let item2 = TodoItem(context: self.context)
        item2.title = "Buy Eggos"
        item2.isDone = false
        self.items.append(item2)
        
        let item3 = TodoItem(context: self.context)
        item3.title = "Destroy Demogorgon"
        item3.isDone = false
        self.items.append(item3)
        saveItems()
    }
    
}

