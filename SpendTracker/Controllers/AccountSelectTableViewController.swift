//
//  AccountSelectController.swift
//  SpendTracker
//
//  Created by Tai Chin Huang on 2021/9/24.
//

import UIKit

protocol AccountSelectTableViewControllerDelegate: AnyObject {
    func accountSelectTableViewController(_ controller: AccountSelectTableViewController, didSelect account: AccountCategory)
}

class AccountSelectTableViewController: UITableViewController {
    
    let accounts = Transaction.accountCategories
    var accountType: AccountCategory?
    weak var delegate: AccountSelectTableViewControllerDelegate?
    var row: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.backBarButtonItem?.tintColor = .white
        
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
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AccountTableViewCell.self)", for: indexPath) as? AccountTableViewCell else {
            return UITableViewCell()
        }
        let account = accounts[indexPath.row]
        cell.configure(account)
        return cell
    }
    // Delegate
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let account = accounts[indexPath.row]
//        self.accountType = account
//        
//        delegate?.accountSelectTableViewController(self, didSelect: accountType!)
//        print(accountType!.rawValue)
//    }
}
