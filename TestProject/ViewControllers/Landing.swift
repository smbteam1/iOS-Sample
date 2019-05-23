//
//  Landing.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit

class Landing: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.performSegue(withIdentifier: "Login", sender: self)
        }

    }
}
