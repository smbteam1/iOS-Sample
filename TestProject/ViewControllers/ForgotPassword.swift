//
//  ForgotPassword.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit

class ForgotPassword: UIViewController, UITextFieldDelegate {

    //MARK:- Outlets
    @IBOutlet weak var emailField: OuterLineTextField!
    @IBOutlet weak var verifyLbl: UILabel!
    @IBOutlet weak var verificationCodeField: OuterLineTextField!
    @IBOutlet weak var passwordField: OuterLineTextField!
    @IBOutlet weak var cPasswordField: OuterLineTextField!
    @IBOutlet weak var forgotView: UIStackView!
    @IBOutlet weak var verifyView: UIStackView!
    
    //MARK:- Objects
    var email = ""
    let loginModel = LoginViewModel()
    var showHidePasswordFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        forgotView.isHidden = false
        verifyView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailField.configureSubViews()
        verificationCodeField.configureSubViews()
        passwordField.configureSubViews()
        cPasswordField.configureSubViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Text field delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        verificationCodeField.resignFirstResponder()
        return true
    }
    
    //MARK: Other functions
    @IBAction func showHidePassword(_ sender: UIButton!) {
        var txtField = UITextField()
        switch sender.tag {
        case 0:
            txtField = verificationCodeField
        case 1:
            txtField = passwordField
        case 2:
            txtField = cPasswordField
        default:
            txtField = verificationCodeField
        }
        if showHidePasswordFlag {
            txtField.isSecureTextEntry = false
            showHidePasswordFlag = false
        }else {
            txtField.isSecureTextEntry = true
            showHidePasswordFlag = true
        }
    }
    @IBAction func passwordVerification() {
        if (verificationCodeField.text?.count)! > 0 {
            if (passwordField.text?.count)! > 5 {
                if passwordField.text == cPasswordField.text {
                    self.view.endEditing(true)
                    loader.startAnimaton(message: "")
                    let keys:[String: String] = [
                        "appkey": "TestProject",
                        "email": email,
                        "otp":verificationCodeField.text!,
                        "password": passwordField.text!
                    ]
                    loginModel.passwordVerifyCode(param: keys, onSuccess: {success in
                        loader.stopAnimaton()
                        self.back()
                    }, onFailure: {failure in
                        loader.stopAnimaton()
                        AlertHelper().showToast(message: failure)
                    })
                }else {
                    AlertHelper().showGSMessage(message: noPasswordMatchAlert, viewC: self, type: 0)
                } 
            }else {
                AlertHelper().showGSMessage(message: passwordLengthAlert, viewC: self, type: 0)
            }            
        }else {
            AlertHelper().showGSMessage(message: noverificationCodeAlert, viewC: self, type: 0)
        }
    }
    @IBAction func forgotPassword() {
        if ValidationHelper().checkEmail(email: emailField.text!) {
            self.view.endEditing(true)
            loader.startAnimaton(message: "")
            let keys:[String: String] = [
                "appkey": "TestProject",
                "email": emailField.text!
            ]
            loginModel.forgotPassword(param: keys, onSuccess: {success in
                loader.stopAnimaton()
                self.email = self.emailField.text!
                self.verifyLbl.text = "You've just received an email containing a verification code on " + self.emailField.text!
                self.verifyLbl.isHidden = false
                self.forgotView.isHidden = true
                self.verifyView.isHidden = false
            }, onFailure: {failure in
                loader.stopAnimaton()
                AlertHelper().showToast(message: failure)
            })
        }else {
            AlertHelper().showGSMessage(message: invalidEmailAlert, viewC: self, type: 0)
        }
    }
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
