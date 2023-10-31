//
//  File.swift
//  LocalStorage1
//
//  Created by Hashfi Alfian Ciyuda on 19/10/23.
//

import UIKit
import CoreData

class EmployeeViewModel {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var entityName: String
    private var managedContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    private(set) var employees: [EmployeeModel] = [] {
        didSet {
            self.bindEmployeeData()
        }
    }
    
    var bindEmployeeData: () -> () = {}
    var bindAlertToVC: (UIAlertController) -> () = { _ in }
    
    init(entityName: String) {
        self.entityName = entityName
        updateData()
    }
    
    // create new data
    private func createEmployee(
        _ id: Int, _ name: String, _ salary: Int
    ){
        let userEntity = NSEntityDescription.entity(
            forEntityName: entityName, in: managedContext
        )
        
        // entity body
        let insert = NSManagedObject(entity: userEntity!, insertInto: managedContext)
        insert.setValue(id, forKey: "id")
        insert.setValue(name, forKey: "name")
        insert.setValue(salary, forKey: "salary")
        
        appDelegate.saveContext()
        updateData()
    }
    
    private func getEmployees() -> [EmployeeModel]{
        var employees = [EmployeeModel]()

        // fetch data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: entityName
        )

        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            employees = result.map { employee in
                return EmployeeModel(
                    id: employee.value(forKey: "id") as! Int,
                    name: employee.value(forKey: "name") as! String,
                    salary: employee.value(forKey: "salary") as! Int
                )
            }
        } catch let err{
            print(err)
        }

        return employees
    }
    
    func updateEmployee(_ id: Int, _ name: String, _ salary: Int){
        // fetch data to delete
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))
        
        do{
            let fetch = try managedContext.fetch(fetchRequest)
            let dataToUpdate = fetch[0] as! NSManagedObject
            dataToUpdate.setValue(id, forKey: "id")
            dataToUpdate.setValue(name, forKey: "name")
            dataToUpdate.setValue(salary, forKey: "salary")
            
            appDelegate.saveContext()
            updateData()
        } catch let err{
            print(err)
        }
    }
    
    func deleteEmployee(_ id:Int){
        // fetch data to delete
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))
        
        do{
            let dataToDelete = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            managedContext.delete(dataToDelete)
            
            appDelegate.saveContext()
            updateData()
        } catch let err{
            print(err)
        }
    }
    
    func updateData() {
        self.employees = getEmployees()
    }
    
    // MARK: Alert
    func showAddEmployeeAlert() {
        let alert = UIAlertController(
            title: "New Employee",
            message: "Fill the form below to add new employee",
            preferredStyle: .alert
        )
        
        alert.addTextField(configurationHandler: {tf in
            tf.placeholder = "Id"
            tf.keyboardType = .numberPad
        })
        
        alert.addTextField(configurationHandler: {tf in
            tf.placeholder = "Name"
        })
        
        alert.addTextField { tf in
            tf.placeholder = "Salary"
            tf.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            
            let id = alert.textFields![0].text!
            let name = alert.textFields![1].text!
            let salary = alert.textFields![2].text!
            
            // check if the textfield is empty
            if id.isEmpty || name.isEmpty || salary.isEmpty {
                let warning = UIAlertController(title: "Warning", message: "Fill all the textfields", preferredStyle: .alert)
                warning.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.bindAlertToVC(warning)
            } else {
                self.createEmployee(Int(id) ?? 0, name, Int(salary) ?? 0)
                let success = UIAlertController(title: "Success", message: "Data employee added", preferredStyle: .alert)
                success.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.bindAlertToVC(success)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.bindAlertToVC(alert)
    }
    
    func showEditEmployeeAlert(
        _ id: Int, _ name: String, _ salary: Int
    ) {
        let alert = UIAlertController(title: "Edit Employee", message: "Fill the form below to edit employee", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {tf in
            tf.isEnabled = false
            tf.placeholder = "Id"
            tf.text = "\(id)"
        })
        
        alert.addTextField(configurationHandler: {tf in
            tf.placeholder = "Name"
            tf.text = name
        })
        
        alert.addTextField { tf in
            tf.placeholder = "Salary"
            tf.keyboardType = .numberPad
            tf.text = "\(salary)"
        }
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
            
            let name = alert.textFields![1].text!
            let salary = alert.textFields![2].text!
            
            // check if the textfield is empty
            if name.isEmpty || salary.isEmpty {
                let warning = UIAlertController(title: "Warning", message: "Name & salary is mandatory", preferredStyle: .alert)
                warning.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.bindAlertToVC(warning)
            } else {
                self.updateEmployee(
                    id,
                    alert.textFields![1].text!,
                    Int(alert.textFields![2].text!) ?? 0
                )
                
                let success = UIAlertController(title: "Success", message: "Data employee updated", preferredStyle: .alert)
                success.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.bindAlertToVC(success)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.bindAlertToVC(alert)
    }

}
