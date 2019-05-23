//
//  ProfileModel.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 5/4/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit

class ProfileModel: NSObject {

    //MARK:- Questions Objects
    var question = ""
    var question_id = ""
    var selected_answer = ""
    var answers = [Answers]()
    
    //MARK:- Profile Objects
    var first_name = ""
    var email = ""
    var age = 0
    var gender = ""
    var dob = ""
    var height = ""
    var defaultHeightMin = String()
    var defaultHeightMax = String()
    var about = ""
    var place_birth = ""
    var education = ""
    var religion = ""
    var raised_in = ""
    var career = ""
    var alcohol = ""
    var pet = ""
    var diet = ""
    var kid = ""
    var smoke = ""
    var truth_lie = ""
    var current_location = ""
    var media = [Media]()
    
    var place_birth_id = 0
    var raised_in_id = 0
    var religion_id = 0
    var pet_id = 0
    var alcohol_id = 0
    var kid_id = 0
    var diet_id = 0
    var smoke_id = 0
    var education_id = 0
    var career_id = 0
    var i_liked = false
    
    func setQuestions(data: NSDictionary) {
        if let _ = data.value(forKey: "question") {
            question = anyToStringConverter(dict: data, key: "question")
        }
        if let _ = data.value(forKey: "question_id") {
            question_id = anyToStringConverter(dict: data, key: "question_id")
        }
        if let _ = data.value(forKey: "selected_answer") {
            selected_answer = anyToStringConverter(dict: data, key: "selected_answer")
        }
        if let data = data.value(forKey: "answers") as? NSArray {
            for item in data {
                let model = Answers()
                model.setAnswers(data: item as! NSDictionary)
                self.answers.append(model)
            }
        }
    }
    
    func setProfile(data: NSDictionary) {
        first_name = data["first_name"] as? String ?? ""
        email = data["email"] as? String ?? ""
        age = data["age"] as? Int ?? 0
        gender = data["gender"] as? String ?? ""
        dob = data["dob"] as? String ?? ""
        height = data["height"] as? String ?? "1.9"
        about = data["about"] as? String ?? ""
        place_birth = data["place_birth"] as? String ?? ""
        education = data["education"] as? String ?? ""
        religion = data["religion"] as? String ?? ""
        raised_in = data["raised_in"] as? String ?? ""
        career = data["career"] as? String ?? ""
        alcohol = data["alcohol"] as? String ?? ""
        pet = data["pet"] as? String ?? ""
        kid = data["kid"] as? String ?? ""
        diet = data["diet"] as? String ?? ""
        smoke = data["smoke"] as? String ?? ""
        truth_lie = data["truth_lie"] as? String ?? ""
        current_location = data["current_location"] as? String ?? ""
        defaultHeightMin = data["default_height_from"] as? String ?? "1.9"
        defaultHeightMax = data["default_height_to"] as? String ?? "9.0"
        
        place_birth_id = data["place_birth_id"] as? Int ?? 0
        raised_in_id = data["raised_in_id"] as? Int ?? 0
        religion_id = data["religion_id"] as? Int ?? 0
        pet_id = data["pet_id"] as? Int ?? 0
        alcohol_id = data["alcohol_id"] as? Int ?? 0
        kid_id = data["kid_id"] as? Int ?? 0
        diet_id = data["diet_id"] as? Int ?? 0
        smoke_id = data["smoke_id"] as? Int ?? 0
        education_id = data["education_id"] as? Int ?? 0
        career_id = data["career_id"] as? Int ?? 0
        

        if let data = data.value(forKey: "media") as? NSArray {
            self.media.removeAll()
            for item in data {
                let model = Media()
                model.setMedia(data: item as! NSDictionary)
                self.media.append(model)
            }
        }
    }
    
}

class Answers: NSObject {
    
    //MARK:- Questions Objects
    var answer = ""
    var title = ""
    var option = ""
    
    func setAnswers(data: NSDictionary) {
        if let _ = data.value(forKey: "option") {
            option = anyToStringConverter(dict: data, key: "option")
        }
        if let _ = data.value(forKey: "title") {
            title = anyToStringConverter(dict: data, key: "title")
        }
        if let _ = data.value(forKey: "answer") {
            answer = anyToStringConverter(dict: data, key: "answer")
        }
    }
}

class Media: NSObject {
    
    //MARK:- Questions Objects
    var url = ""
    var filename = ""
    var type = ""
    var thumbnail = ""
    
    func setMedia(data: NSDictionary) {
        if let _ = data.value(forKey: "url") {
            url = anyToStringConverter(dict: data, key: "url")
        }
        if let _ = data.value(forKey: "filename") {
            filename = anyToStringConverter(dict: data, key: "filename")
        }
        if let _ = data.value(forKey: "type") {
            type = anyToStringConverter(dict: data, key: "type")
        }
        if let _ = data.value(forKey: "thumbnail") {
            thumbnail = anyToStringConverter(dict: data, key: "thumbnail")
        }
    }
}
