//
//  ParkingListViewController.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 10/29/22.
//

import UIKit

class PackingListViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var packingListTableView: UITableView!
    
    var destination : Destination?
    var list = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        packingListTableView.dataSource = self
        packingListTableView.delegate = self
        
        getList()
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newtextField = UITextField()
        var newItem = Item(context: context)
        newItem.isPacked = false
        
        destination?.totalItems += 1
        
        let alert = UIAlertController(title: "Add a Destination to your list", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            
            if let newItemName = newtextField.text {
                if newItemName != "" {
                    newItem.name = newItemName
                    self.destination?.addToListItems(newItem)
                    
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
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentItem = list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! PackingListCell
        
        // has to be the opposite of isPacked
        // So if an item is packed (true), we do NOT hid view ( False )
        cell.checkedView.isHidden =  !currentItem.isPacked
        cell.itemNameLabel.text = currentItem.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var selectedItem = list[indexPath.row]
        
       
        let cell = tableView.cellForRow(at: indexPath) as! PackingListCell
        
        if selectedItem.isPacked == false {
            cell.checkedView.isHidden = false
            selectedItem.isPacked = true
        } else {
            cell.checkedView.isHidden = true
            selectedItem.isPacked = false
        }
        
        coreDataSave()
    }
    
    func selectedRow(tableView: UITableView, indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PackingListCell
        cell.checkedView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action,view,completionHandler) in
            print("I got deleted")
        
            let deleteItem = self.list[indexPath.row]
        
            self.context.delete(deleteItem)
        
            self.coreDataSave()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

//Core data save
extension PackingListViewController {
    
    func getList(){
        
        if let items = destination?.listItems?.allObjects {
            list = items as! [Item]
        } else {
            list = []
        }
        
        self.packingListTableView.reloadData()
    }
    
    
    func coreDataSave(){
       
        do {
            try self.context.save()
        } catch  {
            print(error)
            print("An error in destination saving")
        }
        getList()
    }
    
    
}

