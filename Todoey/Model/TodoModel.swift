//
//  TodoModel.swift
//  Todoey
//
//  Created by Michael Shulman on 11/9/19.
//  Copyright © 2019 Michael Shulman. All rights reserved.
//

import Foundation
import RealmSwift

class TodoModel  {
    var items: Results<TodoItem>?
    var categories: Results<TodoCategory>?
    var realm = try! Realm()
    
    
    
    func save(category: TodoCategory) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
        
    func loadCategories() {
        categories = realm.objects(TodoCategory.self)
    }

    func loadItems(selectedCategory: TodoCategory) {
        items = selectedCategory.items.sorted(byKeyPath: "title", ascending: true)
    }
}

extension Results where Element: TodoItem {
    func filteredBy (_ substring: String) -> Results<TodoItem>? {
        return self.filter("title CONTAINS[cd] %@", substring).sorted(byKeyPath: "dateCreated", ascending: true) as? Results<TodoItem>
    }
}

