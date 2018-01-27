//
//  ViewController.swift
//  Todoey
//
//  Created by ASJ on 2018. 1. 20..
//  Copyright © 2018년 ASJ. All rights reserved.
//

import UIKit

// UITableViewController를 상속받고 바로 연결함으로써 따로 delegate할 필요가 없어짐. 짱짱편함.
class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.done = true
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find Mike2"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Mike3"
        itemArray.append(newItem3)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.

        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            
            itemArray = items
        }
    }
    
    //MARk - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TODoItemCell")
        let item = itemArray[indexPath.row]
        // let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        
        // Ternary Operator ==> value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK - Tableview Delegate Methods.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        // Select 이후 자연스럽게 배경색깔이 사라짐.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user clicks the add item button on our uialert.
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        // alert에 textField를 추가하는 부분.
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
