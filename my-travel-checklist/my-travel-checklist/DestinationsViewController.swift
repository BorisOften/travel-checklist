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
    
    @IBOutlet weak var destinationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDestinations()
        
        destinationTableView.delegate = self
        destinationTableView.dataSource = self
        
        setupLongPressGesture()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newtextField = UITextField()
        
        let newDestination = Destination(context: context)
        
        
        let alert = UIAlertController(title: "Add a Destination to your list", message:nil, preferredStyle: UIAlertController.Style.alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            
            if let newItem = newtextField.text {
                if newItem != ""{
                    newDestination.locationName = newtextField.text!
                    //self.selectedDestination.itemsArray.append(newItem)
                    self.destinations.append(newDestination)
                    self.coreDataSave()
                }
            }
        }

        alert.addTextField { (textField) in
            textField.placeholder = "add a Destination"
            newtextField = textField
        }
        
        alert.addAction(save)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
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
