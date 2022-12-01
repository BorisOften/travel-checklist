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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var destination : Destination?
    var list = [Items]()
    
    var searchBarText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        packingListTableView.dataSource = self
        packingListTableView.delegate = self
        
        searchBar.delegate = self
        
        getList()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newtextField = UITextField()
        var quantityTextField = UITextField()
        
        let newItem = Items(context: context)
        newItem.date = Date()
        newItem.isPacked = false
        
        let alert = UIAlertController(title: "Add an Item to your list", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            
            if let newItemName = newtextField.text, let newQuantity = quantityTextField.text {
                if newItemName != "" {
                    newItem.name = newItemName

                    }
                if newQuantity != "" {
                    newItem.quantity = Int64(newQuantity)!
                }
                self.destination?.addToListItems(newItem)
                self.destination?.totalItems += 1
                
                self.coreDataSave()
                }
            }

        alert.addTextField { (textField) in
            textField.textAlignment = .center
            textField.placeholder = "add an Item"
            newtextField = textField
        }
        alert.addTextField { (textField) in
            textField.textAlignment = .center
            textField.placeholder = "Add quantity (Default is 1)"
            textField.keyboardType = .numberPad
            quantityTextField = textField
        }
        
        alert.addAction(save)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sortButtonPressed(_ sender: UIButton) {
        showActionSheet()
    }
}

//Search Bar
extension PackingListViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarText = searchText
        if searchText.isEmpty{
            getList()
        } else {
            searchForItem(itemName: searchText)
        }
    }
    
    //
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBarText == "" {
            getList()
        } else {
            searchForItem(itemName: searchBarText)
        }
        view.endEditing(true)
    }
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
        
        cell.quantityLabel.text = "x\(currentItem.quantity)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = list[indexPath.row]
       
        let cell = tableView.cellForRow(at: indexPath) as! PackingListCell
        
        if selectedItem.isPacked == false {
            cell.checkedView.isHidden = false
            selectedItem.isPacked = true
            destination?.packedItems += 1
        } else {
            cell.checkedView.isHidden = true
            selectedItem.isPacked = false
            destination?.packedItems -= 1
        }
        
        coreDataSave()

    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action,view,completionHandler) in
            
            let deleteItem = self.list[indexPath.row]
            
            if deleteItem.isPacked{
                self.destination?.packedItems -= 1
            }
        
            self.context.delete(deleteItem)
            self.destination?.totalItems -= 1
            
            self.coreDataSave()
            
            //check search list
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

//Searching function
extension PackingListViewController {

    func searchForItem(itemName : String) {
        var searchedItemList = [Items]()
        getList()
        
        for listItems in list {
            print("Here up")
            print(listItems.name!)
            print(itemName)
            //change both text to be lower case
            if listItems.name!.lowercased().contains(itemName.lowercased()){
                print("Here")
                searchedItemList.append(listItems)
            }
        }
        list = searchedItemList
        self.packingListTableView.reloadData()
    }
}

//Core data save
extension PackingListViewController {
    
    func getList(){
        
        if let items = destination?.listItems?.allObjects {
            list = items as! [Items]
            list = Sorting().sortItems(listArray: list, sortBy: destination?.sortBy ?? "Alphabetically")
            print(destination?.sortBy)
        } else {
            list = []
        }
            
        DispatchQueue.main.async {
            self.packingListTableView.reloadData()
        }
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

//action sheet pressed
extension PackingListViewController {
    
    func showActionSheet(){
        let alert = UIAlertController(title: "Sort By", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Alphabetically", style: .default, handler: { (_) in
            self.list = Sorting().sortItems(listArray: self.list, sortBy: "Alphabetically")
            self.destination?.sortBy = "Alphabetically"
            self.coreDataSave()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Date Added (Earliest First)", style: .default, handler: { (_) in
            self.list = Sorting().sortItems(listArray: self.list, sortBy: "DateEariestFirst")
            self.destination?.sortBy = "DateEariestFirst"
            self.coreDataSave()
        }))
        
        alert.addAction(UIAlertAction(title: "Date Added (Latest First)", style: .default, handler: { (_) in
            self.list = Sorting().sortItems(listArray: self.list, sortBy: "DateLatestFirst")
            self.destination?.sortBy = "DateLatestFirst"
            self.coreDataSave()
        }))
        
        alert.addAction(UIAlertAction(title: "Checked First", style: .default, handler: { (_) in
            self.list = Sorting().sortItems(listArray: self.list, sortBy: "CheckItems")
            self.destination?.sortBy = "CheckItems"
            self.coreDataSave()
        }))
        
        alert.addAction(UIAlertAction(title: "Unchecked First", style: .default, handler: { (_) in
            self.list = Sorting().sortItems(listArray: self.list, sortBy: "UnCheckItems")
            self.destination?.sortBy = "UnCheckItems"
            self.coreDataSave()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true)
    }
}

