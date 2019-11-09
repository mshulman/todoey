//
//  TodoModel.swift
//  Todoey
//
//  Created by Michael Shulman on 11/9/19.
//  Copyright © 2019 Michael Shulman. All rights reserved.
//

import Foundation

class TodoModel: Codable {
    var items: [TodoItem] = []
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.items)
            try data.write(to: dataFilePath!)
        } catch {
            print ("Error encoding Item array, \(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                try self.items = decoder.decode([TodoItem].self, from: data)
            } catch {
                print ("Error decoding Item array, \(error)")
            }
        } 
        
        if self.items.count == 0 {
            loadSampleData()
        }
    }
    
    func loadSampleData(){
        let item1 = TodoItem()
        item1.title = "Find Mike"
        self.items.append(item1)
        
        let item2 = TodoItem()
        item2.title = "Buy Eggos"
        self.items.append(item2)
        
        let item3 = TodoItem()
        item3.title = "Destroy Demogorgon"
        self.items.append(item3)
        saveItems()
    }
    
}

