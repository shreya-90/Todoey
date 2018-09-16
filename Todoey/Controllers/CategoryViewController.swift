//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shreya on 16/09/18.
//  Copyright © 2018 Shreya Pallan. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
       
    }
   
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
  
    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
           
            
            let category = Category(context: self.context)
            category.name = textField.text!
            self.categoryArray.append(category)
            self.saveData()
            
            
            }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            //print(alertTextField.text)
            
            //print("Now")
            textField = alertTextField
        }
        
            alert.addAction(action)
            self.present(alert,animated: true, completion: nil)
            
        
    }
    
    //MARK: - Data Manipulation Methods
    func saveData(){
        do{
            try context.save()
        }catch{
            print("Error ehile saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        print("loading data from DB...")
        do{
        categoryArray = try context.fetch(request)
        }catch{
            print("Error ehile fetching context \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - TableViewDelegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
}
