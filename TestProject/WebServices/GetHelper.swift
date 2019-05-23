//
//  GetHelper.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol GetRequestDelegate: class {
    @objc optional func getResponse(receivedDict: NSDictionary)
    @objc optional func getResponse(receivedArray: [NSDictionary])
    func getResponseFailed(title: String, errorDescription: String)
}

class ServerCallGetHelper: NSObject {
    var alamoFireManager = Alamofire.SessionManager.default
    var delegate: GetRequestDelegate?
    
    func serverGetRequestWithAccessToken(params: [String: Any],
                                         function: String,
                                         onSuccess: @escaping (NSDictionary) -> Void,
                                         onFailure: @escaping (String) -> Void) {
        
        alamoFireManager.request(API_TokenHelper.serverUrl+controllerClient+function+"?", method: .get, parameters: params, encoding: URLEncoding.queryString, headers: getAccessTokenHeader()).responseJSON { response in
            
            print("Request: \(response.request!)")
            print("Response Status: \(response.result.isSuccess)")

            switch(response.result) {
            case .success(_):
                if let json = response.result.value {
                    /*if ((response.response?.allHeaderFields["Authentication"] as AnyObject).boolValue)! {
                        if let accessToken = response.response?.allHeaderFields["x-access-token"] as? String {
                            UserDefaults.standard.set(accessToken, forKey: "AuthToken")
                        }
                        let responseDic = json as! NSDictionary
                        print("Response: \(responseDic)")
                        onSuccess(responseDic)
                    } else {
                        onFailure(authenticationAlert)
                        let window = UIWindow(frame: UIScreen.main.bounds)
                        if let navigationController = window.rootViewController as? UINavigationController {
                            navigationController.popToRootViewController(animated: true)
                        }
                        //self.delegate?.postResponseFailed(title: "Authentication Error", errorDescription: authenticationAlert)
                    }*/
                    if let accessToken = response.response?.allHeaderFields["x-access-token"] as? String {
                        UserDefaults.standard.set(accessToken, forKey: "AuthToken")
                    }
                    let responseDic = json as! NSDictionary
                    print("Response: \(responseDic)")
                    onSuccess(responseDic)
                } else {
                    onFailure(serverErrorAlert)
                    // self.delegate?.postResponseFailed(title: "Server Error", errorDescription: serverErrorAlert)
                }
                break
            case .failure(_):
                print(response.result.error as Any)
                // self.delegate?.postResponseFailed(title: "Error", errorDescription: (response.result.error?.localizedDescription)! as String)
                onFailure((response.result.error?.localizedDescription)! as String)
                break
            }
        }
    }
    
    func serverGetRequestWithRefreshToken(params: [String: Any],
                                          function: String,
                                          onSuccess: @escaping (NSDictionary) -> Void,
                                          onFailure: @escaping (String) -> Void) {

        alamoFireManager.request(API_TokenHelper.serverUrl+controllerClient+function+"?", method: .get, parameters: params, encoding: URLEncoding.queryString, headers: getHeaderWithRefreshToken()).responseJSON { response in
            
            print("Request: \(response.request!)")
            print("Requested: \(response.result.isSuccess)")
            switch(response.result) {
            case .success(_):
                if let json = response.result.value {
                    if ((response.response?.allHeaderFields["Authentication"] as AnyObject).boolValue)! {
                        if let accessToken = response.response?.allHeaderFields["AuthToken"] as? String {
                            UserDefaults.standard.set(accessToken, forKey: "AuthToken")
                        }
                        let responseDic = json as! NSDictionary
                        print("Response: \(responseDic)")
                        onSuccess(responseDic)
                    } else {
                        onFailure(authenticationAlert)
                        let window = UIWindow(frame: UIScreen.main.bounds)
                        if let navigationController = window.rootViewController as? UINavigationController {
                            navigationController.popToRootViewController(animated: true)
                        }
                        //self.delegate?.postResponseFailed(title: "Authentication Error", errorDescription: authenticationAlert)
                    }
                } else {
                    onFailure(serverErrorAlert)
                    // self.delegate?.postResponseFailed(title: "Server Error", errorDescription: serverErrorAlert)
                }
                break
            case .failure(_):
                print(response.result.error as Any)
                // self.delegate?.postResponseFailed(title: "Error", errorDescription: (response.result.error?.localizedDescription)! as String)
                onFailure((response.result.error?.localizedDescription)! as String)
                break
            }
        }
    }
    
    func serverGetRequestWithoutAnyToken(params:[String:Any],
                                         function:String,
                                         onSuccess: @escaping (NSDictionary) -> Void,
                                         onFailure: @escaping (String) -> Void){
        
        alamoFireManager.request(API_TokenHelper.serverUrl+controllerClient+function+"?", method: .get, parameters: params, encoding: URLEncoding.queryString).responseJSON { response in
            
            print("Request: \(response.request!)")
            print("Requested: \(response.result.isSuccess)")
            switch(response.result) {
            case .success(_):
                if let json = response.result.value {
                    if let headers = response.response?.allHeaderFields as? [String: String] {
                        if let accessToken = headers["x-access-token"] {
                            UserDefaults.standard.set(accessToken, forKey: "AuthToken")
                        }
                        if let refreshToken = headers["refresh-token"] {
                            UserDefaults.standard.set(refreshToken, forKey: "RefreshToken")
                        }
                    }
                    let responseDic = json as! NSDictionary
                    print("Response: \(responseDic)")
                    onSuccess(responseDic)
                } else {
                    onFailure(serverErrorAlert)
                }
                break
            case .failure(_):
                print(response.result.error as Any)
                onFailure((response.result.error?.localizedDescription)! as String)
                break
            }
        }
    }
}
