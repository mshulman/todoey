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
    var categories: [TodoCategory] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveData() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
    
    func loadCategories(with request: NSFetchRequest<TodoCategory> = TodoCategory.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), category: TodoCategory) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory = %@", category)

        if let selectedPredicate = request.predicate {      // if the request already had a predicate set
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [selectedPredicate, ])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
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
        saveData()
    }
    
}

