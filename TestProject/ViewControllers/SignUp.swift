//
//  SignUp.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit
import WebKit

class SignUp: UIViewController, OuterLineTextFieldDelegate {

    //MARK:- Outlets
    @IBOutlet var emailField: OuterLineTextField!
    @IBOutlet var passwordField: OuterLineTextField!
    @IBOutlet var cPasswordField: OuterLineTextField!
    @IBOutlet var nameField: OuterLineTextField!
    @IBOutlet var webLoadView: UIView!
    @IBOutlet var webContentView: UIView!
    @IBOutlet var successView: UIView!
    
    //MARK:- Objects
    var webView: WKWebView!
    let signupModel = SignupViewModel()
    var showHidePasswordFlag = false
    var showHideCPasswordFlag = false

    override func loadView() {
        super.loadView()
        webViewSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailField.configureSubViews()
        passwordField.configureSubViews()
        cPasswordField.configureSubViews()
        nameField.configureSubViews()
        
        emailField.otDelegate = self
        passwordField.otDelegate = self
        cPasswordField.otDelegate = self
        nameField.otDelegate = self
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //webView.frame = self.webContentView.frame
    }
    
    // MARK: Text field delegates
    func textFieldShouldBeginEditing(with textField: OuterLineTextField) {
        
    }
    
    func textFieldShouldEndEditing(with textField: OuterLineTextField) {
        
    }
    
    func textFieldShouldReturn(with textField: OuterLineTextField) {
        if textField == nameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        }else if textField == passwordField {
            cPasswordField.becomeFirstResponder()
        }else if textField == cPasswordField {
            cPasswordField.resignFirstResponder()
        }
    }
    
    //MARK: Other functions
    @IBAction func showHidePassword(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if showHidePasswordFlag {
                passwordField.isSecureTextEntry = false
                showHidePasswordFlag = false
            }else {
                passwordField.isSecureTextEntry = true
                showHidePasswordFlag = true
            }
        case 1:
            if showHideCPasswordFlag {
                cPasswordField.isSecureTextEntry = false
                showHideCPasswordFlag = false
            }else {
                cPasswordField.isSecureTextEntry = true
                showHideCPasswordFlag = true
            }
        default:
            return
        }
        
    }
    func webViewSetup() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: CommonClass().screenSize.height-navBarHeightConstant()-100), configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.isOpaque = false
        self.webContentView.addSubview(webView)
    }
    @IBAction func agreePrivacy() {
        UIView.transition(with: webLoadView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.webLoadView.isHidden = true
        })
    }
    @IBAction func showPrivacy() {
        guard let urlLoad = URL(string: API_TokenHelper.termsUrl + "terms_and_conditions.html") else {
            return
        }
        webLoadView.isHidden = false
        let urlLoadRequest = URLRequest(url: urlLoad)
        webView.load(urlLoadRequest)
    }

    @IBAction func signup() {
        if (nameField.text?.count)! > 0 {
            if ValidationHelper().checkEmail(email: emailField.text!)  {
                if (passwordField.text?.count)! > 5 {
                    if passwordField.text == cPasswordField.text {
                        self.view.endEditing(true)
                        loader.startAnimaton(message: "")
                        let keys:[String: String] = [
                            "appkey": "TestProject",
                            "first_name": nameField.text!,
                            "email": emailField.text!,
                            "password": passwordField.text!,
                            "fb_id": "",
                            "lat": currentLatitude,
                            "lng": currentLongitude,
                            "account_type": "normal",
                            "device_id": "",
                            "device_platform": platform,
                            "fcm_token": fcmTokenString
                        ]
                        
                        signupModel.signUpRequest(param: keys, onSuccess: {success in
                            loader.stopAnimaton()
                            self.performSegue(withIdentifier: "VerifyEmail", sender: self)
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
                AlertHelper().showGSMessage(message: invalidEmailAlert, viewC: self, type: 0)
            }
        }else {
            AlertHelper().showGSMessage(message: noFullNameAlert, viewC: self, type: 0)
        }
    }
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? VerifyEmail
        controller?.email = usermodelObj.email
    }
}
//MARK:- FaceBook extension
extension SignUp {
    @IBAction func facebookSignIN() {
        let fblogin = FbLogin()
        fblogin.fetchFbLoginCredentials(VC: self, completionHandler: { status,dict in
            if status {
                loader.startAnimaton(message: "")
                let keys:[String: String] = [
                    "appkey": "TestProject",
                    "first_name": dict["first_name"]!,
                    "email": dict["first_name"]!,
                    "password": "",
                    "fb_id": dict["fbId"]!,
                    "lat": currentLatitude,
                    "lng": currentLongitude,
                    "account_type": "facebook",
                    "device_id": "",
                    "device_platform": platform,
                    "fcm_token": fcmTokenString
                ]
                self.signupModel.signUpRequest(param: keys, onSuccess: {success in
                    loader.stopAnimaton()
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


//MARK:- WKWebView extension
extension SignUp: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.isLoading == false {
            print("loading")
        }
    }
}
