//
//  JsonHelper.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol JsonRequestDelegate: class {
    @objc optional func jsonResponse(receivedDict: NSDictionary)
    @objc optional func jsonResponse(receivedArray: [NSDictionary])
    func jsonResponseFailed(title: String, errorDescription: String)
}

class ServerCallJsonHelper: NSObject {
    
    var alamoFireManager = Alamofire.SessionManager.default
    var delegate: JsonRequestDelegate?
    
    func serverJsonPostRequest(params : [String: Any], function: String, controller: String) {
        
        alamoFireManager.request(API_TokenHelper.serverUrl+controller+function, method:.post, parameters: params, encoding: JSONEncoding.default, headers: getAccessTokenHeader()).responseJSON { response in
            
            print("Request: \(params)")
            print("Request: ",response.request!)
            print("Response Status: \(response.result.isSuccess)")
            
            
            switch(response.result) {
            case .success(_):
                if let json = response.result.value {
                    
                    if let temp = json as? NSDictionary {
                        print("Response: \(temp)")
                        self.delegate?.jsonResponse!(receivedDict:temp)
                    }
                    else {
                        let temp = json as! [NSDictionary]
                        print("Response: \(temp)")
                        self.delegate?.jsonResponse!(receivedArray:temp)
                    }
                    /*
                     let responseDic = json as! NSDictionary
                     print("Response: \(responseDic)")
                     self.delegate?.jsonResponse(receivedDict:responseDic)
                     */
                } else {
                    self.delegate?.jsonResponseFailed(title: "Server Error", errorDescription: "Sorry! Could not connect to server. Please try after some time.")
                }
                break
            case .failure(_):
                print(response.result.error as Any)
                self.delegate?.jsonResponseFailed(title: "Error", errorDescription: (response.result.error?.localizedDescription)! as String)
                break
            }
        }
    }
    
    func serverJsonPostRequestWithCustomURL(url : String)  {
        
        alamoFireManager.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            
            print("Request: ",response.request!)
            print("Requested: \(response.result.isSuccess)")
            
            //            let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
            //            print("Response: \(responseString!)")
            
            switch(response.result) {
            case .success(_):
                if let json = response.result.value {
                    let responseDic = json as! NSDictionary
                    print("Response: \(responseDic)")
                    self.delegate?.jsonResponse!(receivedDict:responseDic)
                } else {
                    self.delegate?.jsonResponseFailed(title: "Server Error", errorDescription: "Sorry! Could not connect to server. Please try after some time.")
                }
                break
            case .failure(_):
                print(response.result.error as Any)
                self.delegate?.jsonResponseFailed(title: "Error", errorDescription: (response.result.error?.localizedDescription)! as String)
                break
            }
        }
    }
}
