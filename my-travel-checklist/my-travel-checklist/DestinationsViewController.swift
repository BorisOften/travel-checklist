//
//  DestinationViewController.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 10/28/22.
//

import UIKit

class DestinationsViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var destinations = [Destination]()
    var selectedDestination: Destination?
    
    var datePicker = UIDatePicker()
    var dateTextField = UITextField()
    var pickedDate = UIDatePicker()
    let toolBar = UIToolbar()
    
        
    @IBOutlet weak var destinationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        fetchDestinations()
        
        destinationTableView.delegate = self
        destinationTableView.dataSource = self
        
        setupLongPressGesture()
        
    }
    

    
    /*@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newDestinationtextField = UITextField()
        var newDatetextField = UITextField()
        
        let newDestination = Destination(context: context)
        
        
        let alert = UIAlertController(title: "Add a Destination to your list", message:nil, preferredStyle: UIAlertController.Style.alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            
            if let newItem = newDestinationtextField.text {
                if newItem != ""{
                    newDestination.locationName = newDestinationtextField.text!
                    //self.selectedDestination.itemsArray.append(newItem)
                    self.destinations.append(newDestination)
                    self.coreDataSave()
                }
            }
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Add a Destination"
            newDestinationtextField = textField
        }
        
        alert.addTextField { (textField) in
            self.doDatePicker()
            textField.inputView = self.datePicker
            textField.inputAccessoryView = self.toolBar
            textField.placeholder = "Add a Date"
            print("This is the date \(self.dateTextField.text)")
            textField.text = self.dateTextField.text
        }
        
        alert.addAction(save)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }*/
}

// Segue
extension DestinationsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToList" {
            
            let packingListVC = segue.destination as! PackingListViewController
            
            packingListVC.destination = selectedDestination
        }
    }
}

// destination tableView
extension DestinationsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        destinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentDestination = destinations[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "destinationCell") as! DestinationCell
        
        cell.locationNameLabel.text = currentDestination.locationName
        
        //cell.packedProgress.progress = Float(currentDestination.itemsPacked / (currentDestination.totalItems() + 1))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedDestination = destinations[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action,view,completionHandler) in
            print("I got deleted")
        
            let deleteDestination = self.destinations[indexPath.row]
            
            self.context.delete(deleteDestination)
            self.coreDataSave()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// Long press table cell
extension DestinationsViewController : UIGestureRecognizerDelegate {
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.destinationTableView.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.destinationTableView)
            if let indexPath = destinationTableView.indexPathForRow(at: touchPoint) {
                
                selectedDestination = destinations[indexPath.row]
               
                var newtextField = UITextField()
                
                let alert = UIAlertController(title: "Edit Destination", message:nil, preferredStyle: UIAlertController.Style.alert)
                
                let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
                    if let newItem = newtextField.text {
                        if newItem != ""{
                            self.selectedDestination!.locationName = newtextField.text!
                            self.coreDataSave()
                        }
                    }
                }

                alert.addTextField { (textField) in
                    textField.text = self.selectedDestination?.locationName
                    newtextField = textField
                }
                
                alert.addAction(save)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}

// Core Data
extension DestinationsViewController {
    
    func fetchDestinations(){
        do {
            self.destinations = try context.fetch(Destination.fetchRequest())
            
            DispatchQueue.main.async {
                self.destinationTableView.reloadData()
            }

        } catch  {
            print("An error fetching")
        }
        self.destinationTableView.reloadData()
    }
    
    
    func coreDataSave(){
       
        do {
            try self.context.save()
        } catch  {
            print(error)
            print("An error in destination saving")
        }
        fetchDestinations()
    }
}


// date picker
extension DestinationsViewController {
    
    func doDatePicker(){
        // DatePicker
      // datePicker = UIDatePicker()
        
        datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date

        // ToolBar
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true

        self.toolBar.isHidden = false

    }

    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateTextField.text = "\(datePicker.date)"
        pickedDate = datePicker
        print("I was clicked")
        print(pickedDate.date)
        //datePicker.isHidden = true
        //self.toolBar.isHidden = true
    }

    @objc func cancelClick() {
        //datePicker.isHidden = true
        //self.toolBar.isHidden = true
        
    }
}
