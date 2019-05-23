//
//  DropDown.swift
//  TestProject
//
//  Created by ArunM on 16/05/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import Foundation
import SwiftyJSON

class DropDown {
    
    var minimumAge = 18
    var maximumAge = 100
    var minimumHeight = 18
    var maximumHeight = 100
    var maximumDistance = 100
    var placeHolderValues = ["PLACE OF BIRTH",  "RAISED IN", "RELIGION", "EDUCATION",
                             "CAREER", "DIET", "ALCOHOL", "SMOKE", "KIDS", "PETS"]
    
    var religions: [[String: Any]] = []
    var placeOfBirths = [[String: Any]]()
    var raisedIns = [[String: Any]]()
    var careers = [[String: Any]]()
    var alcohols = [[String: Any]]()
    var diets = [[String: Any]]()
    var kids = [[String: Any]]()
    var pets = [[String: Any]]()
    var educations = [[String: Any]]()
    var smokes = [[String: Any]]()
    
    var gender = String()
    var diet = String()
    var raisedIn = String()
    var placeOfBirth = String()
    var alcohol = String()
    var kid = String()
    var education = String()
    var religion = String()
    var pet = String()
    var career = String()
    var heightMin = String()
    var heightMax = String()
    var ageMin = String()
    var ageMax = String()
    var distanceRange = String()
    var smoke = String()
    
    var heightRange = String()
    var ageRange = String()
    
    init(json: JSON) {
        let data = json["data"]
        religions = data["religion"].arrayObject as? [[String: Any]] ?? []
        placeOfBirths = data["place_birth"].arrayObject as? [[String: Any]] ?? []
        raisedIns = data["raised_in"].arrayObject as? [[String: Any]] ?? []
        careers = data["career"].arrayObject as? [[String: Any]] ?? []
        diets = data["diets"].arrayObject as? [[String: Any]] ?? []
        kids = data["kids"].arrayObject as? [[String: Any]] ?? []
        pets = data["pets"].arrayObject as? [[String: Any]] ?? []
        educations = data["education"].arrayObject as? [[String: Any]] ?? []
        alcohols = data["alcohol"].arrayObject as? [[String: Any]] ?? []
        smokes = data["smoke"].arrayObject as? [[String: Any]] ?? []
        
        let filteredData = data["filtered_data"].dictionaryValue
        gender = filteredData["gender"]?.stringValue ?? ""
        diet = filteredData["diet"]?.stringValue ?? ""
        raisedIn = filteredData["raised_in"]?.stringValue ?? ""
        placeOfBirth = filteredData["place_birth"]?.stringValue ?? ""
        alcohol = filteredData["alcohol"]?.stringValue ?? ""
        kid = filteredData["kid"]?.stringValue ?? ""
        pet = filteredData["pet"]?.stringValue ?? ""
        education = filteredData["education"]?.stringValue ?? ""
        religion = filteredData["religion"]?.stringValue ?? ""
        career = filteredData["career"]?.stringValue ?? ""
        distanceRange = filteredData["distance"]?.stringValue ?? ""
        heightMin = filteredData["height_from"]?.stringValue ?? ""
        heightMax = filteredData["height_to"]?.stringValue ?? ""
        ageMin = filteredData["age_from"]?.stringValue ?? ""
        ageMax = filteredData["age_to"]?.stringValue ?? ""
        smoke = filteredData["smoke"]?.stringValue ?? ""
        
    }
}
