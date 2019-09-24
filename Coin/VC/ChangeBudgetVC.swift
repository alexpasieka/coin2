//
//  ChangeBudgetVC.swift
//  Coin
//
//  Created by Alex Pasieka on 4/22/19.
//  Copyright © 2019 Alex Pasieka. All rights reserved.
//

import UIKit

// custom new category view controller class
class ChangeBudgetVC: UIViewController, UITextFieldDelegate {
    
    // storyboard references
//    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountField: amountField!
    
    // ivars
    var name: String?
    var maxAmount: Float?
    var currentCategoryIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountField.delegate = self
      
        categoryLabel.text = MyAppData.shared.categories[currentCategoryIndex].name
        amountField.text = String(format: "$%.2f", MyAppData.shared.categories[currentCategoryIndex].maxAmount)
    }
    
    @IBAction func previousCategory(_ sender: Any) {
        currentCategoryIndex = currentCategoryIndex - 1 < 0 ? 0 : currentCategoryIndex - 1
        categoryLabel.text = MyAppData.shared.categories[currentCategoryIndex].name
        amountField.text = String(format: "$%.2f", MyAppData.shared.categories[currentCategoryIndex].maxAmount)
    }
    
    @IBAction func nextCategory(_ sender: Any) {
        currentCategoryIndex = currentCategoryIndex + 1 > MyAppData.shared.categories.count - 1 ? MyAppData.shared.categories.count - 1 : currentCategoryIndex + 1
        categoryLabel.text = MyAppData.shared.categories[currentCategoryIndex].name
        amountField.text = String(format: "$%.2f", MyAppData.shared.categories[currentCategoryIndex].maxAmount)
    }
    
    // MARK: - Navigation
    // create new budget category segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        name = (categoryLabel.text?.count)! > 0 ? categoryLabel.text! : nil
        let max = amountField.text!.dropFirst()
        maxAmount = (max.count) > 0 ? Float(max) : nil
    }
    
    // MARK: - Text Field
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length > 0 && range.location == 0 {
            return false
        }
        return true
    }
    
}
