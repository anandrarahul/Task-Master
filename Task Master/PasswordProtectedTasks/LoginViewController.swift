//
//  LoginViewController.swift
//  Task Master
//
//  Created by Rahul Anand on 12/09/24.
//

import UIKit
import CryptoKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
//    let matchUsername =
//    let matchPassword =
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if let usernametext = self.username.text {
            let usernameData = Data(usernametext.utf8)
            let hashedUsername = SHA256.hash(data: usernameData)
            print("hashedUsername \(hashedUsername)")
        }
        if let passwordtext = self.password.text {
            let passwordData = Data(passwordtext.utf8)
            let hashedPassword = SHA256.hash(data: passwordData)
            print("hashedPassword \(hashedPassword)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
