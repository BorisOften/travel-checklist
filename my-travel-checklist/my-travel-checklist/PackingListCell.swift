//
//  packingListCell.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 10/29/22.
//

import UIKit

class PackingListCell: UITableViewCell {

   
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var cellBackgroundView: UIView!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var checkedView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBackgroundView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
