//
//  PastCell.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 10/30/22.
//

import UIKit

class PastCell: UITableViewCell {
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var itemPackTotalItemsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 8
    }

}
