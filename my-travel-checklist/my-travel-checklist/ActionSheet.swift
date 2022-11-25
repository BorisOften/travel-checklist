//
//  ActionSheet.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 11/24/22.
//

import UIKit

class ActionSheet{
    
    var actionValue: String?
    
    let alert = UIAlertController(title: "Sort By", message: "Please Select an Option", preferredStyle: .actionSheet)
    
    func showActionSheet(controller: UIViewController, destinationOrList: Int){
        
        alert.addAction(UIAlertAction(title: "Alphabetically", style: .default, handler: { (_) in
            self.actionValue = "Alphabetically"
        }))
        
        alert.addAction(UIAlertAction(title: "Date Added (Earliest First)", style: .default, handler: { (_) in
            self.actionValue = "DateAddedEarly"
        }))
        
        alert.addAction(UIAlertAction(title: "Date Added (Latest First)", style: .default, handler: { (_) in
            self.actionValue = "DateAddedLate"
        }))
        
        // 0 for destination and 1 for list
        if (destinationOrList == 0){
            destinationActionShet()
        } else{
            listActionShet()
        }
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        controller.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    private func destinationActionShet() {
        alert.addAction(UIAlertAction(title: "Upcoming", style: .default, handler: { (_) in
            self.actionValue = "Upcoming"
        }))
    }
    
    private func listActionShet() {
        alert.addAction(UIAlertAction(title: "Checked First", style: .default, handler: { (_) in
            self.actionValue = "Upcoming"
        }))
        
        alert.addAction(UIAlertAction(title: "Unchecked First", style: .default, handler: { (_) in
            self.actionValue = "Upcoming"
        }))
    }
    
    func getActionValue() -> String?{
        return actionValue
    }
}


