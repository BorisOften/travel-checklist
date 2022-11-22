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
}

extension PastDestinationsViewController {
    
    func fetchDestinations(){
        do {
            let request = Destination.fetchRequest()
            let todaysDate = Date()
            
            let predicate = NSPredicate(format: "travelDate < %@", todaysDate as NSDate)
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

}
