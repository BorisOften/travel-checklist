//
//  CustomToolbar.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 11/12/22.
//

import UIKit

protocol CustomToolBarDelegate {
    
    func doneButtonPressed()
    
    func cancelButtonPressed()
}


class CustomToolBar : UIToolbar {
    
    var customButtonsDelegate : CustomToolBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//styling
extension CustomToolBar {
    
    func style(){
        barStyle = .default
        isTranslucent = true
        tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        setItems([cancelButton, spaceButton, doneButton], animated: true)
        isUserInteractionEnabled = true
        
        isHidden = false
    }
}

// Functionality
extension CustomToolBar{
    
    @objc func doneClick() {
        customButtonsDelegate?.doneButtonPressed()
    }

    @objc func cancelClick() {
        customButtonsDelegate?.cancelButtonPressed()
    }
}
