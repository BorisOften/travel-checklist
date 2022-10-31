//
//  ParkingListViewController.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 10/29/22.
//

import UIKit

class PackingListViewController: UIViewController {
    
    @IBOutlet weak var packingListTableView: UITableView!
    
    var packingList = [String]()
    var selectedItem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        packingListTableView.dataSource = self
        packingListTableView.delegate = self
        
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
                    self.packingList.append(newItem)
                    self.packingListTableView.reloadData()
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
        self.present(alert, animated: true, completion: nil)    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// packingList TableView
extension PackingListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        packingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentItem = packingList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! PackingListCell
        
        cell.itemNameLabel.text = currentItem
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
