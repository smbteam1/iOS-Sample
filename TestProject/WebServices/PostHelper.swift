//
//  PostHelper.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol PostRequestDelegate: class {
    func postResponse(receivedDict:NSDictionary)
    func postResponseFailed(title: String, errorDescription: String)
}

enum ContentType {
    case urlEncoded, json
}

class ServerCallPostHelper: NSObject {
    
    var alamoFireManager = Alamofire.SessionManager.default
    var delegate: PostRequestDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK:- POST Request
    func serverPostRequestWithAccessToken(params: [String: Any],
                                          function: String,
                                          contentType: ContentType = .json,
                                          onSuccess: @escaping (NSDictionary) -> Void,
                                          onFailure: @escaping (String) -> Void) {
        let encodingType: ParameterEncoding = contentType == .json ? JSONEncoding.default : URLEncoding()
        alamoFireManager.request(API_TokenHelper.serverUrl+controllerClient+function, method: .post, parameters: params, encoding: encodingType, headers: getTokenHeader()).responseJSON { response in
            print("Request: \(API_TokenHelper.serverUrl+controllerClient+function, params)")
            print("Requested: \(response.result.isSuccess)")
            //            let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
            //            print("Response: \(responseString!)")
            switch(response.result) {
            case .success(_):
                if let json = response.result.value {
                    if let headers = response.response?.allHeaderFields as? [String: AnyObject] {
                        if let authentication = headers["Authorization"] as? String{
                            if authentication == "true"{
                                if let accessToken = headers["x-access-token"] {
                                    UserDefaults.standard.set(accessToken, forKey: "AuthToken")
                                }
                                if let refreshToken = headers["refresh-token"] {
                                    UserDefaults.standard.set(refreshToken, forKey: "RefreshToken")
                                }
                                let responseDic = json as! NSDictionary
                                print("Response: \(responseDic)")
                                 onSuccess(responseDic)
                            }else{
                                self.serverPostRequestWithRefreshToken(params: params, function: function, onSuccess: {response in
                                    if (response["status"] as? Bool)!{
                                        onSuccess(response)
                                    }else {
                                        onFailure(response["message"] as! String)
                                    }
                                }, onFailure: { error in
                                    onFailure(error)
                                })
                            }
                        }else {
                            self.serverPostRequestWithRefreshToken(params: params, function: function, onSuccess: {response in
                                if (response["status"] as? Bool)!{
                                    onSuccess(response)
                                }else {
                                    onFailure(response["message"] as! String)
                                }
                            }, onFailure: { error in
                                onFailure(error)
                            })
                        }
                    } else {
                        self.serverPostRequestWithRefreshToken(params: params, function: function, onSuccess: {response in
                            if (response["status"] as? Bool)!{
                                onSuccess(response)
                            }else {
                                onFailure(response["message"] as! String)
                            }
                        }) { error in
                            onFailure(error)
                        }
                    }
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
    func serverPostRequestWithoutAnyToken(params:[String:Any],
                                          function:String,
                                          onSuccess: @escaping (NSDictionary) -> Void,
                                          onFailure: @escaping (String) -> Void){
        alamoFireManager.request(API_TokenHelper.serverUrl+controllerClient+function, method: .post, parameters: params, encoding: JSONEncoding.default) .responseJSON { response in
            
            print("Request: \(API_TokenHelper.serverUrl+controllerClient+function, params)")
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

    func serverPostRequestWithRefreshToken(params: [String: Any],
                                           function: String,
                                           onSuccess: @escaping (NSDictionary) -> Void,
                                           onFailure: @escaping (String) -> Void) {
        alamoFireManager.request(API_TokenHelper.serverUrl+controllerClient+function, method: .post, parameters: params, encoding: JSONEncoding.default, headers: getHeaderWithRefreshToken()).responseJSON { response in
            print("Request: \(API_TokenHelper.serverUrl+controllerClient+function, params)")
            print("Requested: \(response.result.isSuccess)")
            switch(response.result) {
            case .success(_):
                if let json = response.result.value {
                    if ((response.response?.allHeaderFields["Authentication"] as AnyObject).boolValue)! {
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
}

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
