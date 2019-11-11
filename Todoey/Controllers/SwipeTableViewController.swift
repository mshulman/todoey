//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Michael on 11/11/19.
//  Copyright © 2019 Michael Shulman. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self

        return cell
    }
    
    
    //MARK: - Swipe Cell Delegate Methods

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
                
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") {action, indexPath in
            self.deleteFromModel(at: indexPath)
            
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func deleteFromModel(at indexPath: IndexPath) {
        // update our data model
    }
    
}

