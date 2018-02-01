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
import RealmSwift

// UITableViewController를 상속받고 바로 연결함으로써 따로 delegate할 필요가 없어짐. 짱짱편함.
class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    // Item을 추가할 경우, 자동으로 Category를 이어 추가하도록 되어있는 것으로 보임.
    var selectedCategory: Category? {
        
        didSet {
            
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    // UIApplication.shared.delegate : Singleton

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARk - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        if let item = todoItems?[indexPath.row] {
            
            // let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
            cell.textLabel?.text = item.title
            
            // Ternary Operator ==> value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            
            cell.textLabel?.text = "No items in here."
        }
        
        return cell
    }
    
    // MARK - Tableview Delegate Methods.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 선택된 값이 nil이 아니라면 값을 설정하고, realm의 done값을 삭제한다.
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    
                    item.done = !item.done
                }
            }
            catch {
                
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        // Select 이후 자연스럽게 배경색깔이 사라짐.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        
                        // what will happen once the user clicks the add item button on our uialert.
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    
                    print("Error saving new items, \(error)")
                }
            }
            
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
    
    // Read - 변수선언을 안에서 해버림으로써 method의 인풋이 nil이어도 정상작동하도록 변경함.
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
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

        // 목록을 가져오고, 맞게 조건을 걸어 조회한 다음에, 소팅까지 한 후 다시 불러오는 것.
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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
