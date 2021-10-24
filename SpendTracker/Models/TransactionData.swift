//
//  TransactionData.swift
//  SpendTracker
//
//  Created by Tai Chin Huang on 2021/10/18.
//

import UIKit

struct Transaction {
    
    let account: Account
    
    static var expenseCategories: [ExpenseCategory] {
        ExpenseCategory.allCases
    }
    static var incomeCategories: [IncomeCategory] {
        IncomeCategory.allCases
    }
    static var accountCategories: [AccountCategory] {
        AccountCategory.allCases
    }
    static func fetchReceiptImage(imageUrl: URL?, imageView: UIImageView) {
        if let url = imageUrl{
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }else{
            print("沒有照片")
        }
    }
}

struct Account {
    let name: String
    let image: String
}
