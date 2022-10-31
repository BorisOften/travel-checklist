//
//  DestinationViewController.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 10/28/22.
//

import UIKit

class DestinationsViewController: UIViewController{
    
    var destinations = [Destination]()
    var selectedDestination = Destination()
    
    @IBOutlet weak var destinationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        destinationTableView.delegate = self
        destinationTableView.dataSource = self
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newtextField = UITextField()
        var newDestination = Destination()
        
        
        let alert = UIAlertController(title: "Add a Destination to your list", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
                print(newtextField.text)
            
            if let newItem = newtextField.text {
                if newItem != ""{
                    newDestination.locationName = newtextField.text!
                    //self.selectedDestination.itemsArray.append(newItem)
                    self.destinations.append(newDestination)
                    
                    self.destinationTableView.reloadData()
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

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedDestination = destinations[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
}
