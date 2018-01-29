//
//  ViewController.swift
//  Todoey
//
//  Created by ASJ on 2018. 1. 20..
//  Copyright © 2018년 ASJ. All rights reserved.
//

// 검색해볼 것.
// UserDefaults, Codable, Keychain, SQLite, Core Data, Realm

/*
 CoreData가 저장된 경로 :
 /Users/shlee/Library/Developer/Xcode/DerivedData/Todoey-cfcxndjqmqaaaogfxizfbfekqqcu/Build/Intermediates.noindex/Todoey.build/Debug-iphoneos/Todoey.build/DerivedSources/CoreDataGenerated/DataModel
 */

import UIKit
import CoreData

// UITableViewController를 상속받고 바로 연결함으로써 따로 delegate할 필요가 없어짐. 짱짱편함.
class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        
        didSet {
            
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    // UIApplication.shared.delegate : Singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARk - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let item = itemArray[indexPath.row]
        // let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        
        // Ternary Operator ==> value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK - Tableview Delegate Methods.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // itemArray[indexPath.row].setValue("Completed", forKey: "title")
        // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // itemArray.remove(at: indexPath.row)
        // context.delete(itemArray[indexPath.row])
        saveItems()
        
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
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            // In CoreData, we already made a parentCategory realtion.
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
            
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
    
    // Create
    func saveItems() {
        
        
        do {
            
            try context.save()
        }
        catch {
            
            print("Error saving Context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // Read - 변수선언을 안에서 해버림으로써 method의 인풋이 nil이어도 정상작동하도록 변경함.
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        // Request is override. So we have to determine that requests.
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
        }
        else {
            
            request.predicate = categoryPredicate
        }
        
        do {
            
            itemArray = try context.fetch(request)
        }
        catch {
            
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    // Useful Link
    // http://nshipster.com/nspredicate/
    // https://static.realm.io/downloads/files/NSPredicateCheatsheet.pdf?_ga=2.163122428.1965653950.1517145739-1633768109.1517145739
    
    //MARK: When the searchBar is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // 아래는 Objective-C 문법임. 왜?
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)

    }
    
    // When the text is changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // It makes out list default when we click a x-button.
        if(searchBar.text?.count == 0) {
            
            loadItems()
            
            //MARK: Insert search bar update code.
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
