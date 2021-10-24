//
//  AccountTypeTableViewCell.swift
//  SpendTracker
//
//  Created by Tai Chin Huang on 2021/10/20.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    
    func configure(_ account: AccountCategory) {
        accountImageView.image = UIImage(named: "\(account.rawValue)")
        accountLabel.text = account.rawValue
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
