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
    
    var itemArray = ["Fine Mike", "abc", "def"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
    }
    
    //MARk - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    // MARK - Tableview Delegate Methods.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(itemArray[indexPath.row])
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // Select 이후 자연스럽게 배경색깔이 사라짐.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user clicks the add item button on our uialert.
            self.itemArray.append(textField.text!)
        }
        
        // alert에 textField를 추가하는 부분.
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }]
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
