//
//  Extension.swift
//  SpendTracker
//
//  Created by Tai Chin Huang on 2021/10/21.
//

import Foundation
import UIKit

extension UITextField {
    func setKeyboardReturn() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneButton], animated: true)
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonTap() {
        self.resignFirstResponder()
    }
}

extension Array where Element: Equatable {
    func indices(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
    /*
     enumerated() 列舉 -> 回傳array(連續整數由0開始) of element(序列裡面的元素)
     filter() 篩選 -> 回傳array of element並滿足predicate(所定義的邏輯條件)
     map() 映射 -> 回傳array of element並映射closure內容在其中
     */
}
