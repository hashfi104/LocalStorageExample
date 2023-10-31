//
//  ViewController.swift
//  LocalStorage1
//
//  Created by Hashfi Alfian Ciyuda on 19/10/23.
//

import UIKit
import CoreData

private let employeeCell = "EmployeeCell"

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: EmployeeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(
                nibName: "EmployeeTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: employeeCell
        )
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel = EmployeeViewModel(entityName: "Employee")
        viewModel.bindEmployeeData = {
            self.tableView.reloadData()
        }
        viewModel.bindAlertToVC = { alert in
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func addEmployee(_ sender: Any) {
        viewModel.showAddEmployeeAlert()
    }
    
    // MARK: Table View Data Source & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: employeeCell, for: indexPath) as! EmployeeTableViewCell
        cell.setEmployee(employee: viewModel.employees[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showEditEmployeeAlert(
            viewModel.employees[indexPath.row].id,
            viewModel.employees[indexPath.row].name,
            viewModel.employees[indexPath.row].salary
        )
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // call delete method that i've created before
                viewModel.deleteEmployee(viewModel.employees[indexPath.row].id)
            }
        }
}
