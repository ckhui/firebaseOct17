//
//  ViewController.swift
//  FirebaseChatApp
//
//  Created by Max Jala on 09/11/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.addTarget(self, action: #selector(loginInUser), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signupButton: UIButton! {
        didSet {
            signupButton.addTarget(self, action: #selector(signupUser), for: .touchUpInside)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func signupUser() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {return}
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func loginInUser() {
        guard let email = emailTextfield.text,
            let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let validError = error {
                self.alert(title: "Error", message: validError.localizedDescription)
            }
            
            if user != nil {
                
                let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
                
                guard let vc =  storyboard.instantiateViewController(withIdentifier: "ContactsViewController") as? ContactsViewController else {return}
                
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

