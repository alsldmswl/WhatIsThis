//
//  SettingViewController.swift
//  WhatIsThis3
//
//  Created by eun-ji on 2023/04/11.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {

    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        [changePasswordButton, logoutButton].forEach{
            $0?.layer.borderColor = UIColor.label.cgColor
            $0?.layer.borderWidth = 1
            $0?.layer.cornerRadius = 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        changePasswordButton.isHidden = !isEmailSignIn
        let email = Auth.auth().currentUser?.email ?? "고객"
        welcomeLabel.text = """
        환영합니다
        \(email)님
        """
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError {
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
    }
    
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    

}
