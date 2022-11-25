//
//  DestinationCell.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 10/29/22.
//

import UIKit

class DestinationCell: UITableViewCell {

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var itemPackTotalItemsLabel: UILabel!
    //@IBOutlet weak var view: UIView!
    
    @IBOutlet weak var packedProgress: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //view.layer.cornerRadius = 8
        packedProgress.progress = 0
    }

}
