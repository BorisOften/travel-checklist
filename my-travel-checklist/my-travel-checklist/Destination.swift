//
//  Destination.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 10/29/22.
//

import Foundation

struct Destination{
    var locationName: String
    var date: String
    var itemsPacked : Int
    var packingItems: [String]
    
    init(locationName: String = "", date: String = ""){
        self.locationName = locationName
        self.date = date
        itemsPacked = 0
        packingItems = []
    }
    
    func totalItems() -> Int {
        return packingItems.count
    }
}
