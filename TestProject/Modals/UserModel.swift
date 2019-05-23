//
//  UserModel.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit
import CoreLocation

class UserModel: NSObject {

    static let sharedInstance = UserModel()
    var name = ""
    var refreshToken = ""
    var authToken = ""
    var email = ""
    var profileImage = ""
    var user_id = ""
    var is_profile_completed = false
    var is_reg_completed = false
    var phone = ""
    
    func setUserModel(userDict: NSDictionary) {
        if let tempString = userDict.value(forKey: "first_name") {
            print(tempString)
            name = anyToStringConverter(dict: userDict, key: "first_name")
        }
        if let tempString = userDict.value(forKey: "email") {
            print(tempString)
            email = anyToStringConverter(dict: userDict, key: "email")
        }
        if let tempString = userDict.value(forKey: "phone") {
            print(tempString)
            phone = anyToStringConverter(dict: userDict, key: "phone")
        }
        if let tempString = userDict.value(forKey: "user_id") {
            print(tempString)
            user_id = anyToStringConverter(dict: userDict, key: "user_id")
        }
        if let tempString = userDict.value(forKey: "profile_image") {
            print(tempString)
            profileImage = anyToStringConverter(dict: userDict, key: "profile_image")
        }
        if let tempString = userDict.value(forKey: "is_profile_completed") {
            print(tempString)
            is_profile_completed = anyToBoolConverter(dict: userDict, key: "is_profile_completed")
        }
        if let tempString = userDict.value(forKey: "is_reg_completed") {
            print(tempString)
            is_reg_completed = anyToBoolConverter(dict: userDict, key: "is_reg_completed")
        }
    }

    func deleteUserModel() {
        refreshToken = ""
        email = ""
        name = ""
        profileImage = ""
        user_id = ""
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "password")
        defaults.removeObject(forKey: "isLoggedIn")
        defaults.synchronize()
    }
}
