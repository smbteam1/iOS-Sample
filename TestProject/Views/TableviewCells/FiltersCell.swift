//
//  FiltersTableViewCell.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 06/05/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit

protocol FiltersTableViewCellDelegate {
    func textFieldShouldEndEditing(with text: String, textField: OuterLineTextField)
}

class FiltersCell: TableViewCell {

    @IBOutlet weak var filterTextField: OuterLineTextField!
    var delegate: FiltersTableViewCellDelegate?
    var picker = UIPickerView()
    
    var filter: Filters?
    var pickerTitles = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterTextField.otDelegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCellValues(with placeHolder: String, value: String, index: Int) {
        filterTextField.placeholder = placeHolder
        filterTextField.restorationIdentifier = placeHolder
        filterTextField.text = value
        filterTextField.tag = index
        filterTextField.configureSubViews()
        filterTextField.inputView = picker
        picker.delegate = self
        picker.dataSource = self
    }
    
    fileprivate func updatePickerTitle(from identifier: String) {
        let placeHolderType = FiltersViewModel.placeholders.self
        
        switch identifier {
        case placeHolderType.religion.rawValue:
            pickerTitles = filter?.religions.map({$0["name"]}) as! [String]
        case placeHolderType.placeOfBirth.rawValue:
            pickerTitles = filter?.placeOfBirths.map({$0["name"]}) as! [String]
        case placeHolderType.raisedIn.rawValue:
            pickerTitles = filter?.raisedIns.map({$0["name"]}) as! [String]
        case placeHolderType.career.rawValue:
            pickerTitles = filter?.careers.map({$0["name"]}) as! [String]
        case placeHolderType.alcohol.rawValue:
            pickerTitles = filter?.alcohols.map({$0["name"]}) as! [String]
        case placeHolderType.diet.rawValue:
            pickerTitles = filter?.diets.map({$0["name"]}) as! [String]
        case placeHolderType.kids.rawValue:
            pickerTitles = filter?.kids.map({$0["name"]}) as! [String]
        case placeHolderType.pets.rawValue:
            pickerTitles = filter?.pets.map({$0["name"]}) as! [String]
        case placeHolderType.education.rawValue:
            pickerTitles = filter?.educations.map({$0["name"]}) as! [String]
        case placeHolderType.smoke.rawValue:
            pickerTitles = filter?.smokes.map({$0["name"]}) as! [String]
        default:
            break
        }
    }
}

extension FiltersCell: OuterLineTextFieldDelegate {
    func textFieldShouldReturn(with textField: OuterLineTextField) {
        
    }    
    
    func textFieldShouldBeginEditing(with textField: OuterLineTextField) {
        if filter != nil {
        updatePickerTitle(from: textField.restorationIdentifier!)
        }
    }
    
    func textFieldShouldEndEditing(with textField: OuterLineTextField) {
        if filter != nil, pickerTitles.count > 0 {
            let selectedText = pickerTitles[picker.selectedRow(inComponent: 0)]
            textField.text = selectedText
            delegate?.textFieldShouldEndEditing(with: selectedText, textField: textField)
        }
    }
}

extension FiltersCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTitles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerTitles[row]
    }
    
    
}

extension FiltersCell: UIPickerViewDelegate {
    
}
