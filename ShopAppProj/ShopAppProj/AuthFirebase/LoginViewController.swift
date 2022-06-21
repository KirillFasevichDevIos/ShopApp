//
//  LoginViewController.swift
//  ShopAppProj
//
//  Created by admin on 21.06.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref = Database.database().reference(withPath: "users")
        
        // IF WE HAVE REAL TOKEN
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let _ = user else { return }
            self?.performSegue(withIdentifier: "toTasksSegue", sender: nil)
        }
    }

    @IBAction func loginTapped() {
        guard let email = emailTF.text,
              let password = passwordTF.text,
              !email.isEmpty, !password.isEmpty else {
            dispalyWarningLabel(withText: "Empty value")
            return
        }
        
        // create new user
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let error = error {
                self?.dispalyWarningLabel(withText: "Registration error: \(error.localizedDescription)")
            } else if let _ = user {
                self?.performSegue(withIdentifier: "toTasksSegue", sender: nil)
            } else {
                self?.dispalyWarningLabel(withText: "Something wrong")
            }
        }
    }
    
    @IBAction func registerTapped() {
        guard let email = emailTF.text,
              let password = passwordTF.text,
              !email.isEmpty, !password.isEmpty else {
            dispalyWarningLabel(withText: "Empty value")
            return
        }
        
        // create new user
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            if let error = error {
                self?.dispalyWarningLabel(withText: "Registration error: \(error.localizedDescription)")
            } else if let user = user {
                let userRef = self?.ref.child(user.user.uid)
                userRef?.setValue(["email": user.user.email])
            }
        }
    }
    
    // MARK: - Private func
    
    private func dispalyWarningLabel(withText text: String) {
        
        warnLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) { [weak self] in
            self?.warnLabel.alpha = 1
        } completion: { [weak self] _ in
            self?.warnLabel.alpha = 0
        }

        
    }
}

