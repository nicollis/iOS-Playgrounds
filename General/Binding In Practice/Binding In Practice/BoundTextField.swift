//
//  BoundTextField.swift
//  Binding In Practice
//
//  Created by Nic Ollis on 1/27/18.
//  Copyright © 2018 Ollis. All rights reserved.
//

import UIKit

class BoundTextField: UITextField {

    var changedClosure: (() -> ())?
    
    @objc func valueChanged() {
        changedClosure?()
    }
    
    func bind(to observable: Observable<String>) {
        addTarget(self, action: #selector(BoundTextField.valueChanged), for: .editingChanged)
        
        changedClosure = { [weak self] in
            observable.bindingChanged(to: self?.text ?? "")
        }
        
        observable.valueChanged = { [weak self] newValue in
            self?.text = newValue
        }
    }

}
