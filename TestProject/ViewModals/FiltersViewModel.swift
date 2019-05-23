//
//  FiltersViewModel.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 07/05/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import Foundation
import SwiftyJSON


class FiltersViewModel {
    
    enum placeholders: String, CaseIterable {
        case placeOfBirth = "PLACE OF BIRTH"
        case raisedIn = "RAISED IN"
        case religion = "RELIGION"
        case education = "EDUCATION"
        case career = "CAREER"
        case diet = "DIET"
        case alcohol = "ALCOHOL"
        case smoke = "SMOKE"
        case kids = "KIDS"
        case pets = "PETS"
    }
    
    static let shared = FiltersViewModel()
    var placeHolderTexts: [String] {
        return placeholders.allCases.map({$0.rawValue})
    }
    var placeHolderTypes = placeholders.allCases
    
    var placeHolderValues = [String: Any]()
    
    func getPreviousFilterDetails(completion: @escaping(Bool, Filters?, String?) -> Void) {
        ServerCallGetHelper().serverGetRequestWithAccessToken(params: [:], function: "filter_details", onSuccess: { (dictionary) in
            let filter = Filters(json: JSON(dictionary))
            self.setHeightRangeValue(from: filter, min: filter.heightMin, max: filter.heightMax)
            self.setageRangeValue(from: filter, min: filter.ageMin, max: filter.ageMax)
            self.updatePlaceHolderValues(from: filter)
            completion(true, filter, nil)
        }) { (error) in
            completion(false, nil, error)
        }
    }
    
    func saveFilterDetails(with age: String, height: String, distance: String, gender: String, values: [String: Any], filter: Filters, completion: @escaping (Bool, String?, String?) -> Void) {
        
        let params = formUploadDictionary(with: age, height: height, distance: distance, gender: gender, values: values, filter: filter)
        ServerCallPostHelper().serverPostRequestWithAccessToken(params: params, function: "filter", contentType: .urlEncoded, onSuccess: { (responseDictionary) in
            let message = responseDictionary["message"] as? String
            AlertHelper().showToast(message: message ?? "Error")
            completion(true, message, nil)
        }) { (errorMessage) in
            completion(false, nil, nil)
        }
    }
    
    fileprivate func formUploadDictionary(with age: String, height: String, distance: String, gender: String, values: [String: Any], filter: Filters) -> [String: Any] {
        
        var dictionary = [String: Any]()
        dictionary["gender"] = gender
        dictionary["place_birth_id"] = getId(from: filter.placeOfBirths, text: values[placeholders.placeOfBirth.rawValue]!)
        dictionary["raised_in_id"] = getId(from: filter.raisedIns, text: values[placeholders.raisedIn.rawValue]!)
        dictionary["career_id"] = getId(from: filter.careers, text: values[placeholders.career.rawValue]!)
        dictionary["education_id"] = getId(from: filter.educations, text: values[placeholders.education.rawValue]!)
        dictionary["smoke_id"] = getId(from: filter.smokes, text: values[placeholders.smoke.rawValue]!)
        dictionary["religion_id"] = getId(from: filter.religions, text: values[placeholders.religion.rawValue]!)
        dictionary["pets"] = getId(from: filter.pets, text: values[placeholders.pets.rawValue]!)
        dictionary["diet"] = getId(from: filter.diets, text: values[placeholders.diet.rawValue]!)
        dictionary["alcohol"] = getId(from: filter.alcohols, text: values[placeholders.alcohol.rawValue]!)
        dictionary["kids"] = getId(from: filter.kids, text: values[placeholders.kids.rawValue]!)
        dictionary["age_from"] = age.split(separator: "-").first?.replacingOccurrences(of: " ", with: "")
        dictionary["age_to"] = age.split(separator: "-").last?.replacingOccurrences(of: " ", with: "")
        let heightFromValue = height.split(separator: "-").first?.replacingOccurrences(of: "'", with: ".")
        let heightToValue = height.split(separator: "-").last?.replacingOccurrences(of: "'", with: ".")
        dictionary["height_from"] = heightFromValue?.replacingOccurrences(of: " ", with: "")
        dictionary["height_to"] = heightToValue?.replacingOccurrences(of: " ", with: "")
        dictionary["distance"] = distance.split(separator: " ").first
        print(dictionary)
        return dictionary
    }
    
    fileprivate func getId(from item: [[String: Any]], text: Any) -> Int {
        for item in item {
            if item["name"] as! String == text as! String {
                return item["id"] as! Int
            }
        }
        return 0
    }
    
    fileprivate func setHeightRangeValue(from filter: Filters, min: String, max: String) {
        let hMin = min.split(separator: ".")
        let hMax = max.split(separator: ".")
        let hSubMin = hMin.count == 2 ? hMin[1] : "0"
        let hSubMax = hMax.count == 2 ? hMax[1] : "0"
        filter.heightRange = "\(hMin[0])'\(hSubMin) - \(hMax[0])'\(hSubMax)"
    }
    
    fileprivate func setageRangeValue(from filter: Filters, min: String, max: String) {
        filter.ageRange = min + " - " + max
    }
    
    fileprivate func updatePlaceHolderValues(from filter: Filters) {
        let type = placeholders.self
        var filterDetailsDictionary = [String: Any]()
        for item in placeHolderTexts {
            switch item {
            case type.religion.rawValue:
                filterDetailsDictionary[item] = filter.religion
            case type.placeOfBirth.rawValue:
                filterDetailsDictionary[item] = filter.placeOfBirth
            case type.raisedIn.rawValue:
                filterDetailsDictionary[item] = filter.raisedIn
            case type.career.rawValue:
                filterDetailsDictionary[item] = filter.career
            case type.alcohol.rawValue:
                filterDetailsDictionary[item] = filter.alcohol
            case type.diet.rawValue:
                filterDetailsDictionary[item] = filter.diet
            case type.kids.rawValue:
                filterDetailsDictionary[item] = filter.kid
            case type.pets.rawValue:
                filterDetailsDictionary[item] = filter.pet
            case type.education.rawValue:
                filterDetailsDictionary[item] = filter.education
            case type.smoke.rawValue:
                filterDetailsDictionary[item] = filter.smoke
            default:
                break
            }
        }
        placeHolderValues = filterDetailsDictionary
    }
    
}
