//
//  Sorting.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 11/24/22.
//

import UIKit

struct Sorting {
    
    func sortDestination(destinationArray:
                         [Destination], sortBy: String) -> [Destination] {
        
        var list = destinationArray
        
        if sortBy == "Alphabetically" {
            list.sort(by: {$0.locationName!.lowercased() < $1.locationName!.lowercased() })
        } else if sortBy == "DateEariestFirst" {
            list.sort(by: {$0.travelDate! > $1.travelDate! })
        } else if sortBy == "DateLatestFirst" {
            list.sort(by: {$0.travelDate! < $1.travelDate! })
        } 
        
        return list
        
    }
    
    
    func sortItems(listArray:
                   [Items], sortBy: String) -> [Items] {
        
        var list = listArray
        
        if sortBy == "Alphabetically" {
            list.sort(by: {$0.name!.lowercased() < $1.name!.lowercased() })
        } else if sortBy == "DateEariestFirst" {
            list.sort(by: {$0.date! > $1.date! })
        } else if sortBy == "DateLatestFirst" {
            list.sort(by: {$0.date! < $1.date! })
        } else if sortBy == "CheckItems" {
            list.sort(by: {$0.isPacked && !$1.isPacked })
        } else if sortBy == "UnCheckItems" {
            list.sort(by: {!$0.isPacked && $1.isPacked })
        }
        
        return list
    }
        
}
