//
//  AddDestinationViewController.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 11/11/22.
//

import UIKit

class AddDestinationViewController: UIViewController {
    
    
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var destinationErrorLabel: UILabel!
    @IBOutlet weak var dateErrorLabel: UILabel!
    
    var selectedDestination: Destination? = nil
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //date picker
    var datePicker : CustomDatePicker = {
        let datePicker = CustomDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.current
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    let formatter = DateFormatter()
    
    
    // toolbar
    let toolbar = CustomToolBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.customButtonsDelegate = self
        dateErrorLabel.isHidden = true
        destinationErrorLabel.isHidden = true
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
                
        style()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dateErrorLabel.isHidden = true
        destinationErrorLabel.isHidden = true
        
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        if isValidInput(){
            
            if selectedDestination == nil{
                
                let newDestination = Destination(context: context)
                newDestination.locationName = destinationTextField.text
                newDestination.travelDate = datePicker.date
                
                if let currentWeight = weightTextField.text , let currentDes = notesTextView.text{
                    
                    newDestination.weight = Double(currentWeight) ?? 0.0
                    newDestination.notes = currentDes
                }
            } else {
                selectedDestination?.locationName = destinationTextField.text
                selectedDestination?.travelDate = datePicker.date
                
                if let currentWeight = weightTextField.text , let currentDes = notesTextView.text{
                    selectedDestination?.weight = Double(currentWeight) ?? 0.0
                    selectedDestination?.notes = currentDes
                }
            }
            
            do {
                print("I got saved")
                try self.context.save()
            } catch  {
                print(error)
                print("An error in destination saving")
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    //styling
    func style() {
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
        dateTextField.textAlignment = NSTextAlignment.center
        
        destinationTextField.textAlignment = .center
        weightTextField.textAlignment = .center
        weightTextField.keyboardType = .numberPad
        
        //editing a destination
        if selectedDestination != nil {
            destinationTextField.text = selectedDestination?.locationName
            
            
            datePicker.date = (selectedDestination?.travelDate)!
            dateTextField.text = formatter.string(from: (selectedDestination?.travelDate)!)
            print(datePicker.date)
            
            //weight and notes
            if let weight = selectedDestination?.weight, let notes = selectedDestination?.notes{
                weightTextField.text = String(weight)
                notesTextView.text = notes
            }
        }
    }
    
    func isValidInput() -> Bool{
        if destinationTextField.text == "" {
            destinationErrorLabel.isHidden = false
            return false
        } else {
            destinationErrorLabel.isHidden = true
        }
        
        if dateTextField.text == "" {
            dateErrorLabel.isHidden = false
            return false
        } else {
            dateErrorLabel.isHidden = true
        }
        if let date = datePicker.date.startOfDay(), let compareDate = Date().startOfDay() {
            if date < compareDate {
                dateErrorLabel.text = "Travel date can not be before today"
                dateErrorLabel.isHidden = false
                return false
            }
        }
        return true
    }
}

// toolbar delegates
extension AddDestinationViewController: CustomToolBarDelegate {
    
    func doneButtonPressed() {
        
        dateTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    func cancelButtonPressed() {
        view.endEditing(true)
    }
}
