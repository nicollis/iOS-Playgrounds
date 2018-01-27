//
//  ViewController.swift
//  Binding In Practice
//
//  Created by Nic Ollis on 1/27/18.
//  Copyright © 2018 Ollis. All rights reserved.
//

import UIKit

struct User {
    var name: Observable<String>
}

class ViewController: UIViewController {
    
    @IBOutlet weak var username : BoundTextField!
    
    var user = User(name: Observable("Nic Ollis"))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        username.bind(to: user.name)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.user.name.value = "Bilbo Baggins"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

