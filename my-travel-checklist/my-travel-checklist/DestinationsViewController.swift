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
    
    var isEditingDestination = false
    var searchBarText = ""
        
    @IBOutlet weak var destinationTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getList()
        
        destinationTableView.delegate = self
        destinationTableView.dataSource = self
        
        searchBar.delegate = self
        
        
        
        // for testing
        //let newD = Destination(context: context)
        //newD.travelDate = Date(timeIntervalSinceReferenceDate: -129.0)
        //newD.locationName = "This is for Test 2"
        //destinations.append(newD)
        
        setupLongPressGesture()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getList()
        isEditingDestination = false
    }
    @IBAction func sortButtonPressed(_ sender: UIButton) {
        showActionSheet()
    }
    
}

// Segue
extension DestinationsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToList" {
            
            let packingListVC = segue.destination as! PackingListViewController
            
            packingListVC.destination = selectedDestination
        }
        
        if segue.identifier == "goToAddDestination" {
            let editDestinationVC = segue.destination as! AddDestinationViewController
            
            if isEditingDestination {
                editDestinationVC.selectedDestination = selectedDestination
            } else {
                editDestinationVC.selectedDestination = nil
            }
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
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        cell.dateLabel.text = formatter.string(from: currentDestination.travelDate!)
        cell.itemPackTotalItemsLabel.text = "\(currentDestination.packedItems) / \(currentDestination.totalItems)"
        
        if currentDestination.totalItems != 0{
            
            cell.packedProgress.progress = Float(currentDestination.packedItems) / (Float(currentDestination.totalItems))
        } else{
            cell.packedProgress.progress = 0
        }
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
                isEditingDestination = true
                performSegue(withIdentifier: "goToAddDestination", sender: self)
            }
        }
    }
}

// Core Data
extension DestinationsViewController {
    
    func fetchDestinations(){
        do {
            let request = Destination.fetchRequest()
            let todaysDate = Date().startOfDay()
            
            print(todaysDate)
            print(Date().startOfDay())
            let predicate = NSPredicate(format: "travelDate >= %@", todaysDate as! NSDate)
            request.predicate = predicate
            
            self.destinations = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.destinationTableView.reloadData()
            }

        } catch  {
            print("An error fetching")
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

extension DestinationsViewController {
    
    func searchForItem(destinationName : String) {
        var searchedDestinationList = [Destination]()
        fetchDestinations()
        
        for destination in destinations {
            //change both text to be lower case
            if destination.locationName!.lowercased().contains(destinationName.lowercased()) {
                print("Here")
                searchedDestinationList.append(destination)
            }
        }
        destinations = searchedDestinationList
        self.destinationTableView.reloadData()
    }
}

//search bar
extension DestinationsViewController : UISearchBarDelegate {
    
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

extension DestinationsViewController {
    
    func getList(){
        fetchDestinations()
        
        destinations = Sorting().sortDestination(destinationArray: destinations, sortBy: StartState.sortBy)
        self.destinationTableView.reloadData()
    }
}

extension DestinationsViewController {
    
    func showActionSheet(){
        
        let alert = UIAlertController(title: "Sort By", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Alphabetically", style: .default, handler: { (_) in
            self.destinations = Sorting().sortDestination(destinationArray: self.destinations, sortBy: "Alphabetically")
            StartState.sortBy = "Alphabetically"
            self.destinationTableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Travel Date (Earliest First)", style: .default, handler: { (_) in
            self.destinations = Sorting().sortDestination(destinationArray: self.destinations, sortBy: "DateEariestFirst")
            StartState.sortBy = "DateEariestFirst"
            self.destinationTableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Travel Date (Latest First)", style: .default, handler: { (_) in
            self.destinations = Sorting().sortDestination(destinationArray: self.destinations, sortBy: "DateLatestFirst")
            StartState.sortBy = "DateLatestFirst"
            self.destinationTableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true)
    }
}
