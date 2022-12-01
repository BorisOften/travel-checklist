//
//  PastDestinationsViewController.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 10/28/22.
//

import UIKit

class PastDestinationsViewController: UIViewController {
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var pastDestinations = [Destination]()
    var selectedDestination: Destination?
    
    var searchBarText = ""
        
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchDestinations()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
    }
    
    @IBAction func sortButtonPressed(_ sender: UIButton) {
        showActionSheet()
    }
    
}

extension PastDestinationsViewController {
    
    func fetchDestinations(){
        do {
            let request = Destination.fetchRequest()
            let todaysDate = Date()
            
            let predicate = NSPredicate(format: "travelDate <= %@", todaysDate as NSDate)
            request.predicate = predicate
            
            self.pastDestinations = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        } catch  {
            print("An error fetching")
        }
        self.tableView.reloadData()
    }
}

// tableView
extension PastDestinationsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(pastDestinations.count)
        return pastDestinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentDestination = pastDestinations[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastCell") as! PastCell
        
        cell.locationNameLabel.text = currentDestination.locationName
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        cell.dateLabel.text = formatter.string(from: currentDestination.travelDate!)
        cell.itemPackTotalItemsLabel.text = "\(currentDestination.packedItems) / \(currentDestination.totalItems)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedDestination = pastDestinations[indexPath.row]
        performSegue(withIdentifier: "goToPastList", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action,view,completionHandler) in
            print("I got deleted")
        
            let deleteDestination = self.pastDestinations[indexPath.row]
            
            self.context.delete(deleteDestination)
            self.coreDataSave()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// segue
extension PastDestinationsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPastList" {
            
            let packingListVC = segue.destination as! PastListTableViewController
            
            packingListVC.destination = selectedDestination
        }
    }
}

extension PastDestinationsViewController {
    
    func searchForItem(destinationName : String) {
        var searchedDestinationList = [Destination]()
        fetchDestinations()
        
        for destination in pastDestinations {
            //change both text to be lower case
            if destination.locationName!.lowercased().contains(destinationName.lowercased()) {
                print("Here")
                searchedDestinationList.append(destination)
            }
        }
        pastDestinations = searchedDestinationList
        self.tableView.reloadData()
    }
}

//search bar
extension PastDestinationsViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarText = searchText
        
        if searchBarText.isEmpty{
            getList()
        } else {
            searchForItem(destinationName: searchText)
        }
    }
    
    //
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBarText == "" {
            getList()
        } else {
            searchForItem(destinationName: searchBarText)
        }
        view.endEditing(true)
    }
}

extension PastDestinationsViewController {
    
    func getList(){
        fetchDestinations()
        //destinations
        //list.sort(by: {$0.name! > $1.name! })
        //list.sort(by: {!$0.isPacked && $1.isPacked })
        //list.sorted(by: {$0.isPacked > $1.name! })
        
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

extension PastDestinationsViewController {
    
    func showActionSheet(){
        
        let alert = UIAlertController(title: "Sort By", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Alphabetically", style: .default, handler: { (_) in
            self.pastDestinations = Sorting().sortDestination(destinationArray: self.pastDestinations, sortBy: "Alphabetically")
            StartState.sortBy = "Alphabetically"
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Travel Date (Earliest First)", style: .default, handler: { (_) in
            self.pastDestinations = Sorting().sortDestination(destinationArray: self.pastDestinations, sortBy: "DateEariestFirst")
            StartState.sortBy = "DateEariestFirst"
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Travel Date (Latest First)", style: .default, handler: { (_) in
            self.pastDestinations = Sorting().sortDestination(destinationArray: self.pastDestinations, sortBy: "DateLatestFirst")
            StartState.sortBy = "DateLatestFirst"
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true)
    }
}

