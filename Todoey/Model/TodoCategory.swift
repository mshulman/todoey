//
//  TodoCategory.swift
//  Todoey
//
//  Created by Michael on 11/10/19.
//  Copyright © 2019 Michael Shulman. All rights reserved.
//

import Foundation
import RealmSwift

class TodoCategory: Object {
    @objc dynamic var name: String = ""
    let items = List<TodoItem>()
}
