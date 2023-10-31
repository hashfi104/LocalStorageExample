//
//  EmployeeTableViewCell.swift
//  LocalStorage1
//
//  Created by Hashfi Alfian Ciyuda on 19/10/23.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var salaryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setEmployee(employee: EmployeeModel) {
        label.text = "\(employee.id), \(employee.name)"
        salaryLabel.text = "Rp \(employee.salary)"
    }
}
