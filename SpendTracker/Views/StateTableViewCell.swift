//
//  StateTableViewCell.swift
//  SpendTracker
//
//  Created by Tai Chin Huang on 2021/10/23.
//

import UIKit

class StateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    
    var transactionItem: TransactionData!
    
    func configure(_ item: TransactionData) {
        transactionItem = item
        
        categoryImageView.image = UIImage(named: transactionItem.category!)
        categoryLabel.text      = transactionItem.category
        costLabel.text          = String(transactionItem.cost)
        accountLabel.text       = transactionItem.account
        
        switch transactionItem.isExpense {
        case true:
            costLabel.textColor = .systemRed
        case false:
            costLabel.textColor = .systemMint
        }
        
        if transactionItem.contentDescription?.count == 0,
           transactionItem.memo?.count != 0 {
            descriptionLabel.text = transactionItem.memo
        } else {
            descriptionLabel.text = transactionItem.contentDescription
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
