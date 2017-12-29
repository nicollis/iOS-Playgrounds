//
//  ViewController.swift
//  TradeMyTesla
//
//  Created by Nic Ollis on 12/29/17.
//  Copyright © 2017 Ollis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    let cars = Cars()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var model: UISegmentedControl!
    @IBOutlet weak var upgrades: UISegmentedControl!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var mileage: UISlider!
    @IBOutlet weak var condition: UISegmentedControl!
    @IBOutlet weak var valuation: UILabel!
    
    // MARK: IBActions
    
    @IBAction func calculateValue(_ sender: Any) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let formattedMileage = formatter.string(for: mileage.value) ?? "0"
        mileageLabel.text = "MILEAGE (\(formattedMileage) miles)"
        
        // create a prediction by passing in all its input from the UI
        if let prediction = try? cars.prediction(
            model:Double(model.selectedSegmentIndex),
            premium: Double(upgrades.selectedSegmentIndex),
            mileage: Double(mileage.value),
            condition: Double(condition.selectedSegmentIndex)) {
            // clamp the price so it's at least $2000
            let clampedValuation = max(2000, prediction.price)
            
            formatter.numberStyle = .currency
            
            valuation.text = formatter.string(for: clampedValuation)
        } else {
            valuation.text = "Error"
        }
    }
    
    // MARK: ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.setCustomSpacing(30, after: model)
        stackView.setCustomSpacing(30, after: upgrades)
        stackView.setCustomSpacing(30, after: mileage)
        stackView.setCustomSpacing(60, after: condition)
        
        calculateValue(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

