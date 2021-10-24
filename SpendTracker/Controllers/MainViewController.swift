//
//  MainViewController.swift
//  SpendTracker
//
//  Created by Tai Chin Huang on 2021/9/24.
//

import UIKit
import CoreData

class MainViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noItemLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var container: NSPersistentContainer!
    // 負責tableView資料變動後頁面更新
    var fetchResultController: NSFetchedResultsController<TransactionData>!
    var transactionItems: [TransactionData] = [] {
        didSet {
            if transactionItems.isEmpty {
                noItemLabel.isHidden = false
            } else {
                noItemLabel.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.dataSource = self
//        tableView.delegate = self
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonTap))
        fetchData(dateStr: dateFormatter(date: Date()))
        updateUI()
    }
    // 不經segue用present，注意要讓addItemTVC有navigation bar，要連接navC，故要多設定navC然後設定/顯示navC
//    @objc func addItemButtonTap() {
//        guard let addItemTVC = storyboard?.instantiateViewController(withIdentifier: "\(AddItemTableViewController.self)") as? AddItemTableViewController else {
//            return
//        }
//        let navC = UINavigationController(rootViewController: addItemTVC)
//        navC.modalPresentationStyle = .fullScreen
//        addItemTVC.selectedDate = dateFormatter(date: datePicker.date)
//        print("date: \(dateFormatter(date: datePicker.date))")
//        present(navC, animated: true, completion: nil)
//    }
    // 經過segue方式(包含新增跟原本已有資料)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemTableViewController" {
            guard let navC = segue.destination as? UINavigationController,
                  let addItemTVC = navC.viewControllers.first as? AddItemTableViewController,
                  let row = tableView.indexPathForSelectedRow?.row else {
                return
            }
            let transactionItem = transactionItems[row]
            addItemTVC.transactionData = transactionItem
            print("傳送資料")
        } else {
            guard let navC = segue.destination as? UINavigationController,
                  let addItemTVC = navC.viewControllers.first as? AddItemTableViewController else {
                return
            }
            addItemTVC.selectedDate = dateFormatter(date: datePicker.date)
            print("date: \(dateFormatter(date: datePicker.date))")
        }
    }
    
    @IBAction func unwindToMainVC(_ unwindSegue: UIStoryboardSegue) {
        if let sourceVC = unwindSegue.source as? AddItemTableViewController,
           let transactionItem = sourceVC.transactionData {
            let context = container.viewContext
            if tableView.indexPathForSelectedRow != nil {
                print("修改資料")
            } else {
                context.insert(transactionItem)
                print("新增資料")
            }
            container.saveContext()
            tableView.reloadData()
        }
//        guard let sourceVC = unwindSegue.source as? AddItemTableViewController,
//        let transactionItem = sourceVC.transactionData else {
//            return
//        }
//        let context = container.viewContext
//        if tableView.indexPathForSelectedRow != nil {
//            print("修改資料")
//        } else {
//            context.insert(transactionItem)
//            print("新增資料")
//        }
//        container.saveContext()
//        tableView.reloadData()
    }
    
    @IBAction func changeDate(_ sender: UIDatePicker) {
        fetchData(dateStr: dateFormatter(date: datePicker.date))
        tableView.reloadData()
    }
    
    func updateUI() {
        noItemLabel.text = "  No data available,\n  Please click [+] to add new item."
        tableView.backgroundColor = .systemGray5
        datePicker.tintColor = UIColor(named: "MainColor")
    }
    
    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy"
        let dateStr = formatter.string(from: date)
        return dateStr
    }
    
    
    // 從CoreData抓取資料
    func fetchData(dateStr: String) {
        transactionItems.removeAll()
        let fetchRequest: NSFetchRequest<TransactionData> = TransactionData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateStr", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "dateStr == %@", dateFormatter(date: datePicker.date))
        
        let context = container.viewContext
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
            if let fetchObjects = fetchResultController.fetchedObjects {
                transactionItems = fetchObjects
            }
        } catch {
            print("Fail to fetch object from CoreDate, \(error)")
        }
    }
// MARK: - NSFetchedResultsControllerDelegate
    // 即將處理變更時被呼叫
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    // 通知MainViewController manageObjectContext有新增/刪除/移動/更新
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {
                return
            }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {
                return
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            tableView.reloadData()
        case .update:
            guard let indexPath = indexPath else {
                return
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            tableView.reloadData()
        }
        if let fetchObjects = controller.fetchedObjects {
            transactionItems = fetchObjects as! [TransactionData]
        }
    }
    // 完成變更處理時被呼叫
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
// MARK: - UITableView DataSoure/Delegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    // Datasource
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        /*
         這裡使用高階函數.reduce，$0代表結果的數字，$1代表序列裡面的每個元素
         先判斷物件裡面是支出還是收入，假設支出，那將支出裡面的金額體取出來並跟初始值相加(0)，結果就會變成$0
         $0會再跟下一筆符合的$1進行相加，不符合就回傳原本的結果$0
        */
        let expense = transactionItems.reduce(0, {
            if $1.isExpense == true {
                return $0 + Int($1.cost)
            } else {
                return $0
            }
        })
        let income = transactionItems.reduce(0, {
            if $1.isExpense == false {
                return $0 + Int($1.cost)
            } else {
                return $0
            }
        })
        guard !transactionItems.isEmpty else {
            return nil
        }
        return "Expense \(expense)   Income \(income)   Total \(expense - income)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.transactionItemCell, for: indexPath) as? TransactionItemCell else { return UITableViewCell() }
        let transactionItem = transactionItems[indexPath.row]
        cell.configure(transactionItem)
        return cell
    }
    // 預設刪除tableView的function，外加從container.viewContext做刪除動作，在刷新saveContext()完成動作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        container.viewContext.delete(self.fetchResultController.object(at: indexPath))
        container.saveContext()
    }
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        guard let addItemTVC = storyboard?.instantiateViewController(withIdentifier: "\(AddItemTableViewController.self)") as? AddItemTableViewController else {
//            return
//        }
//        let transactionItem = transactionItems[indexPath.row]
//        addItemTVC.transactionData = transactionItem
//        navigationController?.pushViewController(addItemTVC, animated: true)
    }
}
