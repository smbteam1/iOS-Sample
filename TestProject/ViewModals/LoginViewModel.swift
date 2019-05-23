//
//  LoginModel.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject {

    let serverCall = ServerCallPostHelper()
    let functionlogin = "login"
    let functionautologin = "auto_login"
    let functionforgot = "forgot_password"
    
    //MARK: Apis
    func loginRequest(param:[String:Any],onSuccess: @escaping (Bool, String) -> Void, onFailure: @escaping (String) -> Void){
        serverCall.serverPostRequestWithoutAnyToken(params: param, function: functionlogin, onSuccess: {response in
            if (response["status"] as? Bool)!{
                if let data = response.value(forKey: "data") as? NSDictionary{
                    usermodelObj.setUserModel(userDict: data)
                }
                onSuccess(true, response["message"] as! String)
            }else {
                onFailure(response["message"] as! String)
            }
        }) { error in
            onFailure(error)
        }
    }
    func autoLoginRequest(param:[String:String],onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (String) -> Void){
        loader.startAnimaton(message: "")
        serverCall.serverPostRequestWithAccessToken(params: param, function: functionautologin, onSuccess: {response in
            if (response["status"] as? Bool)!{
                if let data = response.value(forKey: "data") as? NSDictionary{
                    usermodelObj.setUserModel(userDict: data)
                }
                onSuccess(true)
            }else {
                onFailure(response["message"] as! String)
            }
            loader.stopAnimaton()
        }) { error in
            loader.stopAnimaton()
            onFailure(error)
        }
    }
    func updateInfo(param:[String:Any],function_name: String, onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (String) -> Void){
        serverCall.serverPostRequestWithAccessToken(params: param, function: function_name, onSuccess: {response in
            if (response["status"] as? Bool)!{
                AlertHelper().showToast(message: response["message"] as! String)
                onSuccess(true)
            }else {
                onFailure(response["message"] as! String)
            }
        }) { error in
            onFailure(error)
        }
    }
    func forgotPassword(param:[String:Any],onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (String) -> Void){
        serverCall.serverPostRequestWithoutAnyToken(params: param, function: "forgot_password", onSuccess: {response in
            if (response["status"] as? Bool)!{
                onSuccess(true)
                AlertHelper().showToast(message: response["message"] as! String)
            }else {
                onFailure(response["message"] as! String)
            }
        }) { error in
            onFailure(error)
        }
    }
    func passwordVerifyCode(param:[String:Any],onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (String) -> Void){
        serverCall.serverPostRequestWithoutAnyToken(params: param, function: "validate_otp_changePassword", onSuccess: {response in
            if (response["status"] as? Bool)!{
                onSuccess(true)
                AlertHelper().showToast(message: response["message"] as! String)
            }else {
                onFailure(response["message"] as! String)
            }
        }) { error in
            onFailure(error)
        }
    }
    func resetPassword(param:[String:Any],onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (String) -> Void){
        serverCall.serverPostRequestWithoutAnyToken(params: param, function: "reset_password", onSuccess: {response in
            if (response["status"] as? Bool)!{
                onSuccess(true)
                AlertHelper().showToast(message: response["message"] as! String)
            }else {
                onFailure(response["message"] as! String)
            }
        }) { error in
            onFailure(error)
        }
    }
    func updateTokenRequest(param:[String:String],onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (String) -> Void){
        serverCall.serverPostRequestWithAccessToken(params: param, function: "update_deviceToken", onSuccess: {response in
            if (response["status"] as? Bool)!{
                onSuccess(true)
            }else {
                onFailure(response["message"] as! String)
            }
        }) { error in
            onFailure(error)
        }
    }
}
