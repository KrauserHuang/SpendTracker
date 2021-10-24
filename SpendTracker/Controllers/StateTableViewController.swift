//
//  StateController.swift
//  SpendTracker
//
//  Created by Tai Chin Huang on 2021/9/24.
//

import UIKit
import CoreData
import Charts

class StateTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    var container: NSPersistentContainer!
    var fetchResultController: NSFetchedResultsController<TransactionData>!
    var transactionItems = [TransactionData]()
    var isExpenseCategory: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        createPieChart()
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 設定圖標位置
        let legend = pieChartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        
    }
    
    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy"
        let dateStr = formatter.string(from: date)
        return dateStr
    }
    
    // 從CoreData抓取資料
    func fetchData() {
        transactionItems.removeAll()
        let fetchRequest: NSFetchRequest<TransactionData> = TransactionData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateStr", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
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
    
    func createPieChart() {
        let pieChartDataEntries = Transaction.expenseCategories.map { (category) -> PieChartDataEntry in
            return PieChartDataEntry(value: Double(perExpenseCategorySum(category: category)), label: category.rawValue)
        }
        // 設定項目顯示樣式，colors(顏色)/selectionShift(點選pie後的凸起動畫)/sliceSpace(pie間的縫隙距離)
        let dataSet = PieChartDataSet(entries: pieChartDataEntries)
//        dataSet.colors = Transaction.expenseCategories.map({ (category) -> UIColor in
//            return UIColor(named: "\(category)") ?? .white
//        })
        dataSet.colors = ChartColorTemplates.vordiplom()
        + ChartColorTemplates.joyful()
        + ChartColorTemplates.colorful()
        + ChartColorTemplates.liberty()
        + ChartColorTemplates.pastel()
        + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        dataSet.selectionShift = 10
        dataSet.sliceSpace = 5
        
        let data = PieChartData(dataSet: dataSet)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        formatter.percentSymbol = " %"
        
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueFont(.systemFont(ofSize: 11, weight: .semibold))
        data.setValueTextColor(.black)
        
        pieChartView.data = data
        
//        let total = transactionItems.reduce(0) { $0 + $1.cost }
        let totalExpense = transactionItems.reduce(0, {
            if $1.isExpense == true {
                return $0 + Int($1.cost)
            } else {
                return $0
            }
        })
        pieChartView.centerText = "Total \n\(totalExpense)"
        // 將pie chart改成百分比
        pieChartView.usePercentValuesEnabled = true
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
//    func numberFormatter() -> NumberFormatter {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .percent
//        formatter.maximumFractionDigits = 1
//        formatter.multiplier = 1.0
//        formatter.percentSymbol = " %"
//        return formatter
//    }
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StateTableViewCell", for: indexPath) as? StateTableViewCell else {
            return UITableViewCell()
        }
        let transactionItem = transactionItems[indexPath.row]
//        if transactionItem.isExpense == true {
//            cell.configure(transactionItem)
//        }
        cell.configure(transactionItem)
//        print(transactionItem)
        return cell
    }
    
    func perExpenseCategorySum(category: ExpenseCategory) -> Int32 {
        let sum = transactionItems.reduce(0) {
            // 如果transactionItems裡項目category有相互對應到就加起來
            if $1.category == category.rawValue {
                return $0 + Int($1.cost)
            } else {
                return $0
            }
        }
        return Int32(sum)
    }
}
