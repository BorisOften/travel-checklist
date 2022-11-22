//
//  CustomDatePicker.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 11/12/22.
//

import UIKit

class CustomDatePicker: UIDatePicker {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Styling
extension CustomDatePicker {
    
    func style() {
        preferredDatePickerStyle = .wheels
        backgroundColor = UIColor.white
        datePickerMode = .date
        print(date)
    }
}
