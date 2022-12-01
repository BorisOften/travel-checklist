//
//  StartState.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 11/26/22.
//

import Foundation

public class StartState {
    
    private enum Keys: String {
        case sortBy
    }
    
    public static var sortBy: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.sortBy.rawValue) ?? "Alphabetically"
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.sortBy.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}

let goat = StartState()
