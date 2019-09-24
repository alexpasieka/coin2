//
//  NewCategoryVC.swift
//  Coin
//
//  Created by Alex Pasieka on 4/22/19.
//  Copyright © 2019 Alex Pasieka. All rights reserved.
//
import UIKit

// custom new category view controller class
class NewCategoryVC: UIViewController, UITextFieldDelegate {
    
    // storyboard references
//    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!

    // ivars
    var name: String?
    var maxAmount: Float?
    var currentCategoryIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountField.delegate = self
      
    }
    
  
    
    @IBAction func previousCategory(_ sender: Any) {
        print(currentCategoryIndex)
        currentCategoryIndex = currentCategoryIndex - 1 < 0 ? 0 : currentCategoryIndex - 1
        print(currentCategoryIndex)
        categoryLabel.text = MyAppData.shared.categories[currentCategoryIndex].name
//        category = MyAppData.shared.categories[currentCategoryIndex].name
    }
    
    @IBAction func nextCategory(_ sender: Any) {
        currentCategoryIndex = currentCategoryIndex + 1 > MyAppData.shared.categories.count - 1 ? MyAppData.shared.categories.count - 1 : currentCategoryIndex + 1
        categoryLabel.text = MyAppData.shared.categories[currentCategoryIndex].name
//        category = MyAppData.shared.categories[currentCategoryIndex].name
    }
    
    // MARK: - Navigation
    // create new budget category segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        name = (categoryLabel.text?.count)! > 0 ? categoryLabel.text! : nil
        maxAmount = (amountField.text?.count)! > 0 ? Float(amountField.text!) : nil
    }
    
    // MARK: - Text Field
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length > 0 && range.location == 0 {
            return false
        }
        return true
    }
    
    
    
}
