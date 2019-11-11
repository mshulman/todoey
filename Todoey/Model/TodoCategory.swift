//
//  TodoCategory.swift
//  Todoey
//
//  Created by Michael on 11/10/19.
//  Copyright © 2019 Michael Shulman. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class TodoCategory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = FlatWhite().hexValue()
    let items = List<TodoItem>()
}
