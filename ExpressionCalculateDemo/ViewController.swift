//
//  ViewController.swift
//  ExpressionCalcDemo
//
//  Created by 王浩 on 16/11/3.
//  Copyright © 2016年 uniproud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func confirmBtnClickMethod(sender: UIButton) {
        
        if let inputString = self.inputTextField.text {
            self.resultLabel.text = ExpressionCalculate.calculateExpression(inputString, paramValues: [String : String]())
        }
        
    }
    

}

