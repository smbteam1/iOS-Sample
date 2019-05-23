//
//  Login.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit
import TransitionButton

class Login: UIViewController, OuterLineTextFieldDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var emailField: OuterLineTextField!
    @IBOutlet weak var passwordField: OuterLineTextField!
    @IBOutlet weak var loginBtn: TransitionButton!
    
    //MARK:- Objects
    let loginModel = LoginViewModel()
    let signupModel = SignupViewModel()
    var lastLoginDetails = NSDictionary()
    var showHidePasswordFlag = false
    var fbProfilePic = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        emailField.text = "anu@mailinator.com"
        passwordField.text = "abcdefgh"
        #endif
        //autoLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailField.configureSubViews()
        passwordField.configureSubViews()
        emailField.otDelegate = self
        passwordField.otDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == self.view {
            self.view.endEditing(true)
        }
    }
    
    //MARK: Text field delegates
    func textFieldShouldBeginEditing(with textField: OuterLineTextField) {
        
    }
    
    func textFieldShouldEndEditing(with textField: OuterLineTextField) {
        
    }
    
    func textFieldShouldReturn(with textField: OuterLineTextField) {
       if textField == emailField {
            passwordField.becomeFirstResponder()
        }else if textField == passwordField {
            passwordField.resignFirstResponder()
        }
    }
    
    //MARK: Other functions
    @IBAction func showHidePassword() {
        if showHidePasswordFlag {
            passwordField.isSecureTextEntry = false
            showHidePasswordFlag = false
        }else {
            passwordField.isSecureTextEntry = true
            showHidePasswordFlag = true
        }
    }
    func autoLogin() {
        if Connectivity.isConnectedToInternet {
            if ((UserDefaults.standard.value(forKey: "AuthToken")) != nil)  {
                self.view.endEditing(true)
                loader.startAnimaton(message: "")
                let keys:[String: String] = [:]
                
                loginModel.autoLoginRequest(param: keys, onSuccess: {success in
                    loader.stopAnimaton()
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    if !usermodelObj.is_reg_completed {
                        self.performSegue(withIdentifier: "VerifyEmail", sender: self)
                    }else if !usermodelObj.is_profile_completed {
                        self.performSegue(withIdentifier: "WelcomeProfile", sender: self)
                    }else {
                        self.performSegue(withIdentifier: "tabBarVC", sender: self)
                    }
                }, onFailure: {failure in
                    loader.stopAnimaton()
                    AlertHelper().showAlertOnCurrentVC(title: "Access Denied", message: failure, btnTitle: "OK") {
                    }
                })
            }
        }else {
            AlertHelper().showToast(message: "No Internet Connection")
        }
    }
    @IBAction func login() {
        if ValidationHelper().checkEmail(email: emailField.text!) {
            if (passwordField.text?.count)! > 0 {
                if Connectivity.isConnectedToInternet {
                    self.view.endEditing(true)
                    loader.startAnimaton(message: "")
                    let keys:[String: String] = [
                        "appkey": "TestProject",
                        "email": emailField.text!,
                        "password":passwordField.text!,
                        "lat": currentLatitude,
                        "lng": currentLongitude,
                        "account_type": "normal",
                        "device_platform": platform,
                        "fcm_token": fcmTokenString
                    ]
                    
                    loginModel.loginRequest(param: keys, onSuccess: {success, message in
                        loader.stopAnimaton()
                        UserDefaults.standard.set(self.emailField.text, forKey: "username")
                        UserDefaults.standard.set(self.passwordField.text, forKey: "password")
                        self.emailField.text = ""
                        self.passwordField.text = ""
                        
                        if !usermodelObj.is_reg_completed {
                            self.performSegue(withIdentifier: "VerifyEmail", sender: self)
                        }else if !usermodelObj.is_profile_completed {
                            self.performSegue(withIdentifier: "WelcomeProfile", sender: self)
                        }else {
                            self.performSegue(withIdentifier: "tabBarVC", sender: self)
                        }
                        /*let filtersViewController = self.storyboard?.instantiateViewController(withIdentifier: FiltersViewController.identifier) as! FiltersViewController
                        self.navigationController?.pushViewController(filtersViewController, animated: true)*/
                        
                    }, onFailure: {failure in
                        loader.stopAnimaton()
                        AlertHelper().showAlertOnCurrentVC(title: "Access Denied", message: failure, btnTitle: "OK") {
                        }
                    })
                }else {
                    AlertHelper().showToast(message: "No Internet Connection")
                }
                
            }else {
                AlertHelper().showGSMessage(message: noLoginPasswordAlert, viewC: self, type: 0)
            }
        }else {
            AlertHelper().showGSMessage(message: invalidEmailAlert, viewC: self, type: 0)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WelcomeProfile" {
            let controller = segue.destination as? WelcomeProfile
            controller?.fbProfilePic = fbProfilePic
        }
    }
}
//MARK:- FaceBook extension
extension Login {
    @IBAction func facebookSignIN() {
        let fblogin = FbLogin()
        fblogin.fetchFbLoginCredentials(VC: self, completionHandler: { status,dict in
            if status {
                loader.startAnimaton(message: "")
                let keys:[String: String] = [
                    "appkey": "TestProject",
                    "first_name": dict["name"]!,
                    "email": dict["email"]!,
                    "password": "",
                    "fb_id": dict["fbId"]!,
                    "lat": currentLatitude,
                    "lng": currentLongitude,
                    "account_type": "facebook",
                    "device_id": "",
                    "device_platform": platform,
                    "fcm_token": fcmTokenString
                ]
                self.fbProfilePic = dict["profilePic"] ?? ""
                self.signupModel.signUpRequest(param: keys, onSuccess: {success in
                    loader.stopAnimaton()
                    UserDefaults.standard.set(usermodelObj.email, forKey: "username")
                    UserDefaults.standard.set("", forKey: "password")
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    
                    if !usermodelObj.is_profile_completed {
                        self.performSegue(withIdentifier: "WelcomeProfile", sender: self)
                    }else {
                        self.performSegue(withIdentifier: "tabBarVC", sender: self)
                    }
                }, onFailure: {failure in
                    loader.stopAnimaton()
                    AlertHelper().showToast(message: failure)
                })
            }else {
                AlertHelper().showToast(message: "Faild to login with FaceBook")
            }
        })
    }
}
