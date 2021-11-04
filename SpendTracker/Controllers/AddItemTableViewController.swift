//
//  AddItemTableViewController.swift
//  SpendTracker
//
//  Created by Tai Chin Huang on 2021/10/18.
//

import UIKit

class AddItemTableViewController: UITableViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    // section1
    @IBOutlet weak var dateTextField: UITextField!
    // section2
    @IBOutlet weak var costTextField: UITextField!
    // section3
    @IBOutlet weak var descriptionTextField: UITextField!
    // section4
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    // section5
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    // section6
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    // section7
    @IBOutlet weak var memoTextField: UITextField!
    
//    var account: AccountCategory?
//    var existingTransactionData: TransactionData?
//    let accountSelectTableViewController = AccountSelectTableViewController()
    var selectedDate: String?
    let datePicker = UIDatePicker()
    var isExpenseCategory: Bool = true
    var transactionData: TransactionData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelEditingTap))
//        navigationItem.leftBarButtonItem?.tintColor = .systemBackground
        navigationController?.navigationBar.tintColor = .white
        
        if let transactionData = transactionData {
            self.transactionData = transactionData
        }
        
        updateUI()
    }
    
    @objc func cancelEditingTap() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        //set segmentControl text Color
        segmentControl.setTitleTextAttributes([.foregroundColor:UIColor(named: "MainColor") ?? UIColor.black], for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor:UIColor.white], for: .normal)
        // set textField keyboard
        descriptionTextField.keyboardType = .default
        descriptionTextField.setKeyboardReturn()
        costTextField.keyboardType = .numberPad
        costTextField.setKeyboardReturn()
        memoTextField.keyboardType = .default
        memoTextField.setKeyboardReturn()
        // set datePicker
        createDatePicker()
        // 預判有沒有資料載入
        // if 有資料處理方式 else 沒資料處理方式
        if let transactionData = transactionData {
            
            dateTextField.text = transactionData.dateStr
            
            if transactionData.cost == 0 {
                costTextField.text = ""
            } else {
                costTextField.text = String(transactionData.cost)
            }
            
            descriptionTextField.text = transactionData.contentDescription
            
            categoryImageView.image = UIImage(named: transactionData.category!)
            categoryLabel.text = transactionData.category
            
            accountImageView.image = UIImage(named: transactionData.account!)
            accountLabel.text = transactionData.account

            if transactionData.isExpense == true {
                segmentControl.selectedSegmentIndex = 0
            } else {
                segmentControl.selectedSegmentIndex = 1
            }
            isExpenseCategory = transactionData.isExpense

            if transactionData.image != nil {
                receiptImageView.image = UIImage(data: transactionData.image!)
            } else if transactionData.memo != nil {
                memoTextField.text = transactionData.memo
            }
        } else {
            dateTextField.text = selectedDate
            categoryImageView.image = UIImage(named: Transaction.expenseCategories.first?.rawValue ?? "")
            categoryLabel.text = Transaction.expenseCategories.first?.rawValue
            accountImageView.image = UIImage(named: Transaction.accountCategories.first?.rawValue ?? "")
            accountLabel.text = Transaction.accountCategories.first?.rawValue
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let mainVC = segue.destination as? MainViewController else {
//            return
//        }
        if segue.identifier == "CategorySelectTableViewController" {
            let categorySelectTVC = segue.destination as? CategorySelectTableViewController
            categorySelectTVC?.isExpenseCategory = isExpenseCategory
            print(isExpenseCategory)
        }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if transactionData == nil {
            print("準備新增")
            let transactionItem = TransactionData(context: (appDelegate?.persistentContainer.viewContext)!)
            transactionItem.dateStr = dateTextField.text
            transactionItem.category = categoryLabel.text
            transactionItem.contentDescription = descriptionTextField.text
            transactionItem.cost = Int32(costTextField.text!) ?? 0
            transactionItem.account = accountLabel.text
            transactionItem.isExpense = isExpenseCategory
            transactionItem.memo = memoTextField.text
            
            if let photo = receiptImageView.image {
                transactionItem.image = photo.pngData()
            }
            transactionData = transactionItem
        } else {
            print("更新回去")
            transactionData?.dateStr = dateTextField.text
            transactionData?.category = categoryLabel.text
            transactionData?.contentDescription = descriptionTextField.text
            transactionData?.cost = Int32(costTextField.text!) ?? 0
            transactionData?.account = accountLabel.text
            transactionData?.isExpense = isExpenseCategory
            transactionData?.memo = memoTextField.text
            
            if let photoData = receiptImageView.image?.pngData() {
                transactionData?.image = photoData
            }
        }
    }
    @IBSegueAction func toCategorySelectTVC(_ coder: NSCoder) -> CategorySelectTableViewController? {
        return CategorySelectTableViewController(coder: coder, isExpenseCategory: isExpenseCategory)
    }
    
    // MARK: - SegmentControl change
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            isExpenseCategory = true
            transactionData?.isExpense = true
            costTextField.text = ""
            descriptionTextField.text = ""
            categoryImageView.image = UIImage(named: Transaction.expenseCategories.first!.rawValue)
            categoryLabel.text = Transaction.expenseCategories.first?.rawValue
            memoTextField.text = ""
        case 1:
            isExpenseCategory = false
            transactionData?.isExpense = false
            costTextField.text = ""
            descriptionTextField.text = ""
            categoryImageView.image = UIImage(named: Transaction.incomeCategories.first!.rawValue)
            categoryLabel.text = Transaction.incomeCategories.first?.rawValue
            memoTextField.text = ""
        default:
            break
        }
    }
    // MARK: - dateTextField setting
    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy"
        let dateStr = formatter.string(from: date)
        return dateStr
    }
    
    func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = setDatePickerReturn()
    }
    
    func setDatePickerReturn() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneButton], animated: true)
        
        return toolBar
    }
    
    @objc func doneButtonTap() {
        dateTextField.text = dateFormatter(date: datePicker.date)
        self.view.endEditing(true)
    }
    // MARK: - cameraButton setting
    @IBAction func selectPhoto(_ sender: UIButton) {
        selectImagePickerController()
    }
    
    func incompleteAlert() {
        let alertController = UIAlertController(title: "Something missing", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - UITableView DataSource/Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dataCategory = DataCategory.allCases[indexPath.row]
        switch dataCategory {
        case .date:
            print("You press date")
            return
        case .cost:
            print("You press cost")
            return
        case .contentDescription:
            print("You press contentDescription")
            return
        case .category:
            print("You press category")
            print(isExpenseCategory)
            performSegue(withIdentifier: "\(CategorySelectTableViewController.self)", sender: nil)
        case .account:
            print("You press account")
            performSegue(withIdentifier: "\(AccountSelectTableViewController.self)", sender: nil)
        case .receiptPhoto:
            print("You press receiptPhoto")
            return
        case .memo:
            print("You press memo")
            return
        }
    }
    @IBAction func unwindToAddItemTVC(_ unwindSegue: UIStoryboardSegue) {
        if let sourceVC = unwindSegue.source as? CategorySelectTableViewController,
           let row = sourceVC.row {
            switch segmentControl.selectedSegmentIndex {
            case 0:
                transactionData?.isExpense = true
                let category = Transaction.expenseCategories[row].rawValue
                categoryImageView.image = UIImage(named: category)
                categoryLabel.text = category
            case 1:
                transactionData?.isExpense = false
                let category = Transaction.incomeCategories[row].rawValue
                categoryImageView.image = UIImage(named: category)
                categoryLabel.text = category
            default:
                break
            }
        } else if let sourceVC = unwindSegue.source as? AccountSelectTableViewController,
                  let row = sourceVC.row {
            let account = Transaction.accountCategories[row].rawValue
            accountImageView.image = UIImage(named: account)
            accountLabel.text = account
        }
        tableView.reloadData()
    }
}
// MARK: - UITextFieldDelegate
extension AddItemTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
// MARK: - UIImagePickerControllerDelegate(UINavigationControllerDelegate required)
extension AddItemTableViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        receiptImageView.image = info[.originalImage] as? UIImage
        cameraButton.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    func presentImagePicker(_ sourceType: UIImagePickerController.SourceType = .photoLibrary) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    func selectImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(
                title: "Select input",
                message: nil,
                preferredStyle: .alert
            )
            let cameraAction = UIAlertAction(
                title: "Camera",
                style: .default) { [weak self] _ in
                    self?.presentImagePicker(.camera)
                    print("User select to use camera")
                }
            let photoLibraryAction = UIAlertAction(
                title: "Photo Library",
                style: .default) { [weak self] _ in
                    self?.presentImagePicker()
                    print("User select to use photo library")
                }
            
            alertController.addAction(cameraAction)
            alertController.addAction(photoLibraryAction)
            present(alertController, animated: true, completion: nil)
        } else {
            presentImagePicker()
        }
    }
}
// MARK: - AccountSelectTableViewControllerDelegate
//extension AddItemTableViewController: AccountSelectTableViewControllerDelegate {
//    func accountSelectTableViewController(_ controller: AccountSelectTableViewController, didSelect account: AccountCategory) {
//        self.account = account
//        updateAccountCategory()
//        tableView.reloadData()
//    }
//
//    func updateAccountCategory() {
//        if let accountType = account {
//            print(accountType.rawValue)
//            accountLabel.text = accountType.rawValue
//        } else {
//            accountLabel.text = Transaction.accountCategories.first?.rawValue
//        }
//    }
//}
