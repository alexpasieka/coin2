//
//  InputSpendingVC.swift
//  Coin
//
//  Created by Alex Pasieka on 4/22/19.
//  Copyright © 2019 Alex Pasieka. All rights reserved.
//

import UIKit

// MARK: - Styling

var cornerRadius: CGFloat = 0

class header: UIView {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
}

class body: UIView {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner]
    }
}

class saveButton: UIButton {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}

class amountField: UITextField {
    override func draw(_ rect: CGRect) {
        self.borderStyle = .none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

// custom input spending view controller class
class InputSpendingVC: UIViewController, UITextFieldDelegate {
    
    // storyboard references
    @IBOutlet weak var header: header!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var categoryField: UITableView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    // ivars
    var amount: Float?
    var category: String?
    var currentCategoryIndex: Int = 0
    
    @IBAction func previousCategory(_ sender: Any) {
        currentCategoryIndex = currentCategoryIndex - 1 < 0 ? 0 : currentCategoryIndex - 1
        categoryLabel.text = MyAppData.shared.categories[currentCategoryIndex].name
        category = MyAppData.shared.categories[currentCategoryIndex].name
    }
    
    @IBAction func nextCategory(_ sender: Any) {
        currentCategoryIndex = currentCategoryIndex + 1 > MyAppData.shared.categories.count - 1 ? MyAppData.shared.categories.count - 1 : currentCategoryIndex + 1
        categoryLabel.text = MyAppData.shared.categories[currentCategoryIndex].name
        category = MyAppData.shared.categories[currentCategoryIndex].name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryLabel.text = MyAppData.shared.categories[currentCategoryIndex].name
        
        amountField.delegate = self
        cornerRadius = header.self.frame.height / 2
    }
    
    // MARK: - Text Field
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length > 0 && range.location == 0 {
            return false
        }
        return true
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindWithSaveTapped", sender: self)
    }
    
    // MARK: - Navigation
    
    // save input spending amount (and category) segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let a = String(amountField.text!.dropFirst())
        amount = a.count > 0 ? Float(a) : nil
        category = categoryLabel.text
    }
    
}
