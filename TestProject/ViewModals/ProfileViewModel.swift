//
//  ProfileViewModel.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 5/4/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit

class ProfileViewModel: NSObject {
    
    
    let serverCall = ServerCallPostHelper()
    let serverGetCall = ServerCallGetHelper()
    let profileModel = ProfileModel()
    var questionsModelArr = [ProfileModel]()
    var profileModelArr = [ProfileModel]()
    
    func profileRequest(param:[String:String], function_name: String, onSuccess: @escaping (Bool, String) -> Void, onFailure: @escaping (String) -> Void){
        loader.startAnimaton(message: "")
        serverGetCall.serverGetRequestWithAccessToken(params: param, function: function_name, onSuccess: {response in
            if (response["status"] as? Bool)!{
                if function_name == "get_questions" {
                    if let data = response.value(forKey: "data") as? NSArray {
                        self.questionsModelArr.removeAll()
                        for item in data {
                            let model = ProfileModel()
                            model.setQuestions(data: item as! NSDictionary)
                            self.questionsModelArr.append(model)
                        }
                    }
                }else if function_name == "get_user_profile" {
                    if let data = response.value(forKey: "data") as? NSDictionary {
                        self.profileModel.setProfile(data: data)
                    }
                }
                onSuccess(true, response["message"] as! String)
            }else {
                onFailure(response["message"] as! String)
            }
            loader.stopAnimaton()
        }) { error in
            loader.stopAnimaton()
            onFailure(error)
        }
    }
    
    func profileSetting(param:[String:String], function_name: String, onSuccess: @escaping (Bool, String) -> Void, onFailure: @escaping (String) -> Void){
        loader.startAnimaton(message: "")
        serverCall.serverPostRequestWithAccessToken(params: param, function: function_name, onSuccess: {response in
            if (response["status"] as? Bool)!{
                onSuccess(true, response["message"] as! String)
            }else {
                onFailure(response["message"] as! String)
            }
            loader.stopAnimaton()
        }) { error in
            loader.stopAnimaton()
            onFailure(error)
        }
    }
    
    func saveProfile(param:[String:Any], function_name: String, onSuccess: @escaping (Bool, String) -> Void, onFailure: @escaping (String) -> Void){
        loader.startAnimaton(message: "")
        serverCall.serverPostRequestWithAccessToken(params: param, function: function_name, contentType: .urlEncoded, onSuccess: {response in
            if (response["status"] as? Bool)!{
                if function_name == "user_profile" {
                    AlertHelper().showToast(message: response["message"] as! String)
                }
                onSuccess(true, response["message"] as! String)
            }else {
                onFailure(response["message"] as! String)
            }
            loader.stopAnimaton()
        }) { error in
            loader.stopAnimaton()
            onFailure(error)
        }
    }
    
    func setSelectedAnswer(fieldVal: String, arrIndx: Int) {
        let item = ["selected_answer": fieldVal]
        self.questionsModelArr[arrIndx].selected_answer = fieldVal
        let model = ProfileModel()
        model.setQuestions(data: item as NSDictionary)
    }

}
