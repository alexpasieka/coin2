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
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        amountField.delegate = self
    }
    
    // ivars
    var name: String?
    var maxAmount: Float?
    
    // MARK: - Navigation
    // create new budget category segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        name = (nameField.text?.count)! > 0 ? nameField.text! : nil
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
