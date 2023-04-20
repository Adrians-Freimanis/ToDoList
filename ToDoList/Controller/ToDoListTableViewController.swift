//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by adrians.freimanis on 20/04/2023.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {
    
    var manageObjectContext: NSManagedObjectContext?
    var ToDoLists = [ToDo]()
//    var ToDos = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let  appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjectContext = appDelegate.persistentContainer.viewContext
        
        loadData()
    }
    
    
    
    
    func loadData(){
        let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        do{
            let result = try manageObjectContext?.fetch(request)
            
            ToDoLists = result!
            
            tableView.reloadData()
                    
        }catch{
            fatalError("Error in loading items in ToDoList")
        }
    }
    
    
    
    
    func saveData(){
        do{
            try manageObjectContext?.save()
            
        }catch{
            fatalError("Error saving to do list item")
        }
        loadData()
    }
    
    
    

    @IBAction func addNewItemTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "To do List", message: "Do you want to add new to do list?", preferredStyle: .alert)
        
        alertController.addTextField{
            textInfo in
            textInfo.placeholder = "Main title"
            print(textInfo)
        }
        
        let addActionButton = UIAlertAction(title: "Add", style: .default){
            alertAction in
            let textField = alertController.textFields?.first
            
            let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: self.manageObjectContext!)
            
            let list = NSManagedObject(entity: entity!, insertInto: self.manageObjectContext)
            
            list.setValue(textField?.text, forKey: "item")
            self.saveData()
            
//            self.ToDos.append(textField!.text!)
//            self.tableView.reloadData()
        }
        
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(addActionButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
    }
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ToDoLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        let todo = ToDoLists[indexPath.row]
        cell.textLabel?.text = todo.value(forKey: "item") as? String
        cell.accessoryType = todo.completed ? .checkmark: .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ToDoLists[indexPath.row].completed = !ToDoLists[indexPath.row].completed
        saveData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    #warning("Delete from manageObjectContext")
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
