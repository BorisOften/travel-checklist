//
//  StartOfDayDateExtension.swift
//  my-travel-checklist
//
//  Created by Boris Ofon on 11/27/22.
//

import Foundation

extension Date {

    func startOfDay() -> Date?
    {
        let calendar = Calendar.current

        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)

        components.minute = 0
        components.second = 0

        return calendar.date(from: components)
    }

}
