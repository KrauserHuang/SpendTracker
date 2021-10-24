//
//  Enums.swift
//  SpendTracker
//
//  Created by Tai Chin Huang on 2021/10/18.
//

import Foundation

enum DataCategory: String, CaseIterable, Codable {
    case date, cost, contentDescription, category, account, receiptPhoto, memo
}

enum ExpenseCategory: String, CaseIterable, Codable {
    case food = "Food"
    case transport = "Transport"
    case medical = "Medical"
    case house = "House"
    case entertainment = "Entertainment"
    case education = "Education"
}
enum IncomeCategory: String, CaseIterable, Codable {
    case salary = "Salary"
    case bonus = "Bonus"
    case investment = "Investment"
}
enum AccountCategory: String, CaseIterable, Codable {
    case cash = "Cash"
    case bank = "Bank"
    case creditCard = "Credit Card"
}
