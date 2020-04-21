//
//  ItemsTableViewController.swift
//  DailyDose
//
//  Created by PHANTOM on 21/04/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import CoreData

class ItemsTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let name = itemArray[indexPath.row].title
        
        cell.textLabel?.text = name
        
        let done = itemArray[indexPath.row].done
        
        cell.accessoryType = done == true ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Manipulation Data
    
    func saveItems(){
        
        do {
            
            try context.save()
            
        } catch {
            
        print("Error saving the items data \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            
            request.predicate = categoryPredicate
            
        }
        
        do {
            
            itemArray = try context.fetch(request)
            
        } catch {
            
            print("Error loading the items data \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    // MARK: - Add Items Data
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.parentCategory = self.selectedCategory
            newItem.done = false
            
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTF) in
            alertTF.placeholder = "Create new item"
            textField = alertTF
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

extension ItemsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                       searchBar.resignFirstResponder()
                   }
        }
    
    }
    
}
