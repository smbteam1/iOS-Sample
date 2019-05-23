//
//  Filters.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 07/05/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import Foundation
import SwiftyJSON

class Filters {
    
    var minimumAge = 18
    var maximumAge = 80
    var minimumHeight = 1.8
    var maximumHeight = 6.5
    var maximumDistance = 50
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
        distanceRange = filteredData["distance"]?.stringValue ?? "\(maximumDistance)"
        heightMin = filteredData["height_from"]?.stringValue ?? "\(minimumHeight)"
        heightMax = filteredData["height_to"]?.stringValue ?? "\(maximumHeight)"
        ageMin = filteredData["age_from"]?.stringValue ?? "\(minimumAge)"
        ageMax = filteredData["age_to"]?.stringValue ?? "\(maximumAge)"
        smoke = filteredData["smoke"]?.stringValue ?? ""
        
    }
}
