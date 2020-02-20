//
//  ViewController.swift
//  SwiftyProteins
//
//  Created by Ihor KOVALENKO on 12/16/19.
//  Copyright © 2019 Ihor KOVALENKO. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var swiftyTittle: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    let context = LAContext()
    
    @IBAction func loginButton(_ sender: Any) {
        authentification();
    }
    
    func authentification() {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "You need to be authentificated"){ success, error in
                DispatchQueue.main.async {
                if success
                {
                    print ("Touch ID succed")
                        self.performSegue(withIdentifier: "logIn", sender: "")
                }
                else
                {
                    print("TOUCH ID FAILURE")
                    let alert = UIAlertController(title: "Warning", message: "Authentication failed!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                }
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {

        swiftyTittle.adjustsFontSizeToFitWidth = true
        swiftyTittle.minimumScaleFactor = 0.2
        loginButton.isHidden = true;
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        {
            loginButton.isHidden = false
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

