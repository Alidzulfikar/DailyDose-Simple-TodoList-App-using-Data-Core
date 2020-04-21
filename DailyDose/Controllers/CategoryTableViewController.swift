//
//  ViewController.swift
//  DailyDose
//
//  Created by PHANTOM on 21/04/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import CoreData

class CatagoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadCategory()
    }
    
    
    // MARK: - Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveCategory(){
        
        do {
            
            try context.save()
            
        } catch {
            
            print("Error saving category \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            
            categories = try context.fetch(request)
        
        } catch {
            
            print("Errod loading the data \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Add Data Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            self.saveCategory()

        }
        
        alert.addTextField { (alertTF) in
            alertTF.placeholder = "Create a new category"
            textField = alertTF
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemsTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories[indexPath.row]
            
        }
    }
    
    
    


}

