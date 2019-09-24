//
//  MyAppData.swift
//  Coin
//
//  Created by Alex Pasieka on 4/23/19.
//  Copyright © 2019 Alex Pasieka. All rights reserved.
//

import Foundation

// custom singleton saved app data class
class MyAppData {
    
    // single instance of class
    static let shared = MyAppData()
    
    // last user activity date
    let lastActivityDateKey: String = "lastActivityDateKey"
    var lastActivityDate: Date = Date() {
        didSet {
            // save to disk
            let defaults = UserDefaults.standard
            defaults.set(lastActivityDate, forKey: lastActivityDateKey)
        }
    }
    
    // current budget categories
    let categoriesKey: String = "categoriesKey"
    var categories: [Category] = [Category]() {
        didSet {
            // sort categories alphabetically
            categories = categories.sorted(by: { $0.moneySpent > $1.moneySpent })
            // save to disk (by encoding to JSON)
            let defaults = UserDefaults.standard
            try! defaults.set(JSONEncoder().encode(categories), forKey: categoriesKey)
        }
    }
    
    // past budgets (months)
    let pastMonthsKey: String = "pastMonthsKey"
    var pastMonths: [Month] = [Month]() {
        didSet {
            // save to disk (by encoding to JSON)
            let defaults = UserDefaults.standard
            try! defaults.set(JSONEncoder().encode(pastMonths), forKey: pastMonthsKey)
        }
    }
    
    // designated private initializer
    private init() {
        readDefaultsData()
        
        // TODO - appends new categories every time app is launched
        categories.append(Category(name: "Gas", maxAmount: 0.00, moneyLeftToSpend: 0.00, moneySpent: 0.00, color: 0xFA6B5C))
        categories.append(Category(name: "Food", maxAmount: 0.00, moneyLeftToSpend: 0.00, moneySpent: 0.00, color: 0xFCCB62))
        categories.append(Category(name: "Rent", maxAmount: 0.00, moneyLeftToSpend: 0.00, moneySpent: 0.00, color: 0x6F20DF))
        categories.append(Category(name: "Fun", maxAmount: 0.00, moneyLeftToSpend: 0.00, moneySpent: 0.00, color: 0xC43BFB))
        categories.append(Category(name: "Clothing", maxAmount: 0.00, moneyLeftToSpend: 0.00, moneySpent: 0.00, color: 0x54C4F9))
        categories.append(Category(name: "Presents", maxAmount: 0.00, moneyLeftToSpend: 0.00, moneySpent: 0.00, color: 0xD32B2B))
        categories.append(Category(name: "Pets", maxAmount: 0.00, moneyLeftToSpend: 0.00, moneySpent: 0.00, color: 0x61E59E))
        categories.append(Category(name: "School", maxAmount: 0.00, moneyLeftToSpend: 0.00, moneySpent: 0.00, color: 0x4D53EF))
        categories.append(Category(name: "Other", maxAmount: 0.00, moneyLeftToSpend: 0.00, moneySpent: 0.00, color: 0x88B884))
    }
    
    // read saved data from disk
    private func readDefaultsData() {
        let defaults = UserDefaults.standard
        
        // read last activity date
        if let s = defaults.object(forKey: lastActivityDateKey) {
            lastActivityDate = s as! Date
        }
        else {
            lastActivityDate = Date()
        }
        
        // read current budget categories
        if let s = defaults.object(forKey: categoriesKey) {
            guard let encodedData = defaults.object(forKey: categoriesKey) as? Data else { return }
            categories = try! JSONDecoder().decode([Category].self, from: encodedData)
        }
        else {
            categories = [Category]()
        }
        
        // read past budgets (months)
        if let s = defaults.object(forKey: pastMonthsKey) {
            guard let encodedData = defaults.object(forKey: pastMonthsKey) as? Data else { return }
            pastMonths = try! JSONDecoder().decode([Month].self, from: encodedData)
        }
        else {
            pastMonths = [Month]()
        }
    }
    
}
