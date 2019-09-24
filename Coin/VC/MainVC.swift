//
//  ViewController.swift
//  Coin
//
//  Created by Alex Pasieka on 4/18/19.
//  Copyright © 2019 Alex Pasieka. All rights reserved.
//

import UIKit

// MARK: - Styling TODO

class mainHeader: UIView {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
}


class barGraph: UIView {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}

class mainBody: UIView {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 50
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

class pastMonthsButton: UIButton {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }
}

class changeBudgetButton: UIButton {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner]
    }
}

// helper function for using hex values for colors
// source: https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

// custom main view controller class
class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // storyboard references
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var moneyLeftToSpendLabel: UILabel!
    @IBOutlet weak var categoryList: UITableView!
    @IBOutlet weak var barGraph: UIView!
    
    // ivars
    var moneyLeftToSpend: Float = 0.00
    var moneySpent: Float = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // reset budget if month has changed
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        let lastMonthNumber = Int(formatter.string(from: MyAppData.shared.lastActivityDate))
        let currentMonthNumber = Int(formatter.string(from: Date()))
        if lastMonthNumber! != currentMonthNumber! {
            // add last month budget data to past months data
            var allMonths = MyAppData.shared.pastMonths
            formatter.dateFormat = "MMMM yyyy"
            allMonths.append(Month(name: formatter.string(from: MyAppData.shared.lastActivityDate), report: MyAppData.shared.categories))
            MyAppData.shared.pastMonths = allMonths
            
            // reset budget
            MyAppData.shared.categories = [Category]()
        }
        
        // display current month
        formatter.dateFormat = "MMM yyyy"
        currentMonthLabel.text = formatter.string(from: Date())
        
        // calculate money left to spend
        moneyLeftToSpend = 0.00
        for c in MyAppData.shared.categories {
            moneyLeftToSpend += c.moneyLeftToSpend
        }
        
        // calculate money spent
        moneySpent = 0.00
        for c in MyAppData.shared.categories {
            moneySpent += c.moneySpent
        }
        
        // display calculated budget information
        moneyLeftToSpendLabel.text = String(format: "$%.2f", moneyLeftToSpend)
        
        // if the user has over spent
        if moneyLeftToSpend < 0.00 {
            moneyLeftToSpendLabel.text = String(format: "-$%.2f", abs(moneyLeftToSpend))
            moneyLeftToSpendLabel.textColor = UIColor(rgb: 0xFA765C)
        }
        
        // load category list data
        categoryList.dataSource = self
        categoryList.delegate = self
        categoryList.reloadData()
        
        // save current date to user defaults as last activity date
        MyAppData.shared.lastActivityDate = Date()
        
        // TODO
        var previousWidth: CGFloat = 0
        var startX: CGFloat = 0
        
        for c in MyAppData.shared.categories {
            startX = startX + previousWidth
            
            let portion = CAShapeLayer()
            portion.path = UIBezierPath(roundedRect: CGRect(x: startX, y: 0, width: CGFloat(c.moneySpent / moneySpent) * barGraph.frame.width, height: barGraph.frame.height), cornerRadius: 0).cgPath
            portion.fillColor = UIColor(rgb: c.color).cgColor
            barGraph.layer.addSublayer(portion)
            
            previousWidth = CGFloat(c.moneySpent / moneySpent) * barGraph.frame.width
        }
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyAppData.shared.categories.count
    }
    
    // TODO
    let legendWidth: CGFloat = 15
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // initialize cell (using detailed cell style)
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "categoryCell")
        cell.backgroundColor = UIColor.clear
        let category = MyAppData.shared.categories[indexPath.row]
        let portion = CAShapeLayer()
        portion.path = UIBezierPath(roundedRect: CGRect(x: 15, y: (cell.frame.height / 2) - (legendWidth / 2), width: legendWidth, height: legendWidth), cornerRadius: legendWidth / 2).cgPath
        portion.fillColor = UIColor(rgb: category.color).cgColor
        cell.layer.addSublayer(portion)
        
        // for each current budget category
        if category.moneyLeftToSpend < 0.00 {
            cell.detailTextLabel?.textColor = UIColor(rgb: 0xFA765C)
        }
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = String(format: "$%.2f / $%.2f", category.moneySpent, category.maxAmount)
        
        return cell
    }
    
    // MARK: - Navigation
    
    // TODO
    // done input spending segue
    @IBAction func unwindWithSaveTapped(segue: UIStoryboardSegue) {
        // initialize segue source
        if let inputSpendingVC = segue.source as? InputSpendingVC {
            // if both fields were filled out
            if let amount = inputSpendingVC.amount, let category = inputSpendingVC.category {
                // find category
                if let c = MyAppData.shared.categories.first(where: { $0.name == category }) {
                    // remove category
                    MyAppData.shared.categories = MyAppData.shared.categories.filter { $0.name != c.name }
                    
                    // update category
                    c.moneyLeftToSpend -= amount
                    c.moneySpent += amount
                    
                    // re-append category
                    MyAppData.shared.categories.append(c)
                    
                    // reload main view
                    viewDidLoad()
                }
            }
        }
    }
    
    @IBAction func unwindWithDoneTapped(segue: UIStoryboardSegue) {
        // initialize segue source
       
        if let changeBudgetVC = segue.source as? ChangeBudgetVC {
            // if both fields were filled out
            
            if let maxAmount = changeBudgetVC.maxAmount{
                // create the new category
                //                var categories = MyAppData.shared.categories
                //                categories.append(Category(name: name, maxAmount: maxAmount, moneyLeftToSpend: maxAmount, moneySpent: 0.00))
                //                MyAppData.shared.categories = categories
                MyAppData.shared.categories[changeBudgetVC.currentCategoryIndex].maxAmount = maxAmount
                MyAppData.shared.categories[changeBudgetVC.currentCategoryIndex].moneyLeftToSpend = maxAmount - MyAppData.shared.categories[changeBudgetVC.currentCategoryIndex].moneySpent
                  print(maxAmount)
                print(MyAppData.shared.categories[changeBudgetVC.currentCategoryIndex].maxAmount)
                
            }
        }
        viewDidLoad()
    }

}
