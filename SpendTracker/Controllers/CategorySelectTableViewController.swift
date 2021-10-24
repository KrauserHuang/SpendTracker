//
//  CategorySelectTableViewController.swift
//  SpendTracker
//
//  Created by Tai Chin Huang on 2021/10/22.
//

import UIKit

class CategorySelectTableViewController: UITableViewController {
    
    var row: Int?
    var isExpenseCategory: Bool?
    var isExpense: Bool = true
    
    init?(coder: NSCoder, isExpenseCategory: Bool) {
        self.isExpenseCategory = isExpenseCategory
        super.init(coder: coder)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        row = tableView.indexPathForSelectedRow?.row
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpenseCategory == true {
            return Transaction.expenseCategories.count
        } else {
            return Transaction.incomeCategories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CategoryTableViewCell.self)", for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        if isExpenseCategory == true {
            let category = Transaction.expenseCategories[indexPath.row]
            cell.categoryImageView.image = UIImage(named: "\(category.rawValue)")
            cell.categoryLabel.text = category.rawValue
        } else {
            let category = Transaction.incomeCategories[indexPath.row]
            cell.categoryImageView.image = UIImage(named: "\(category.rawValue)")
            cell.categoryLabel.text = category.rawValue
        }
        return cell
    }
}
