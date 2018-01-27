//
//  Observable.swift
//  Binding In Practice
//
//  Created by Nic Ollis on 1/27/18.
//  Copyright © 2018 Ollis. All rights reserved.
//

import Foundation

class Observable<ObservedType> {
    private var _value: ObservedType?
    var valueChanged: ((ObservedType?) -> ())?
    
    public var value: ObservedType? {
        get {
            return _value
        }
        
        set {
            _value = newValue
            valueChanged?(_value)
        }
    }
    
    init(_ value: ObservedType) {
        _value = value
    }
    
    func bindingChanged(to newValue: ObservedType) {
        _value = newValue
        print("Value is now \(newValue)")
    }
}
