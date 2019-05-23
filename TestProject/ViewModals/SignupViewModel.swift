//
//  SignupViewModel.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit

class SignupViewModel: NSObject {
    let serverCall = ServerCallPostHelper()
    func signUpRequest(param:[String:Any],onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (String) -> Void){
        serverCall.serverPostRequestWithoutAnyToken(params: param, function: "registration", onSuccess: {response in
            if (response["status"] as? Bool)!{
                if let data = response.value(forKey: "data") as? NSDictionary{
                    usermodelObj.setUserModel(userDict: data)
                }
                if param["account_type"] as! String == "normal" {
                    AlertHelper().showToast(message: response["message"] as! String)
                }
                onSuccess(true)
            }else {
             onFailure(response["message"] as! String)
            }
        }) { error in
            onFailure(error)
        }
    }

    func verifySignUpRequest(param:[String:Any],onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (String) -> Void){
        serverCall.serverPostRequestWithoutAnyToken(params: param, function: "verifyCode", onSuccess: {response in
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
    func resendCode(param:[String:Any],onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (String) -> Void){
        serverCall.serverPostRequestWithoutAnyToken(params: param, function: "resendCode", onSuccess: {response in
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
}
