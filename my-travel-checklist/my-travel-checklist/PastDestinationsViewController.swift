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
        
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchDestinations()
        
        tableView.dataSource = self
        tableView.delegate = self
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
}
