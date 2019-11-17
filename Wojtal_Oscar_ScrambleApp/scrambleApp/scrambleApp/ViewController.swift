//
//  ViewController.swift
//  scrambleApp
//
//  Created by Os on 2019-03-05.
//  Copyright © 2019 Os. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userNameTextFeild: UITextField!
    
    var usernameNow: String? = nil

   
    
    @IBAction func letsPlayButtonPressed(_ sender: Any) {
        
        usernameNow = userNameTextFeild.text!
        
        if userNameTextFeild.hasText == true {
        self.performSegue (withIdentifier: "goToGame", sender: self)
        } else {
            view.shake()
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        guard let viewController = segue.destination as? GameViewController else { return }
        viewController.username = usernameNow
    }
   
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
}

