//
//  FiltersViewController.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 06/05/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit
import TTRangeSlider

class FiltersViewController: ViewController {

    //MARK:- Outlets
    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var upgradeBtnView: UIView!
    @IBOutlet var rangeSlider: [TTRangeSlider]!
    @IBOutlet weak var ageRangeLabel: UILabel!
    @IBOutlet weak var heightRangeLabel: UILabel!
    @IBOutlet weak var distanceRangeLabel: UILabel!
    @IBOutlet var genderButton: [UIButton]!
    @IBOutlet weak var upgradeBtn: UIButton!
    
    //MARK:- Objects
    var placeHolderTexts = FiltersViewModel.shared.placeHolderTexts
    var placeHolderValues = [String: Any]()
    var filterDict: [String: String] = [:]
    var gender = String()
    var filter: Filters?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRangeSlider()
        configureFiltersNavigationBar()
        configureStatusBar(with: .white)
        getFilterDetails()
        upgradeBtn.dropShadow(width: upgradeBtn.frame.width, height: upgradeBtn.frame.height, color: UIColor(red: 74/255, green: 105/255, blue: 200/255, alpha: 0.59))
        upgradeBtnView.dropShadow(width: upgradeBtnView.frame.width, height: upgradeBtnView.frame.height, color: UIColor(red: 74/255, green: 105/255, blue: 200/255, alpha: 0.69))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        configureFiltersTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        configureStatusBar(with: .clear)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK: RangeSlide
    func configureRangeSlider() {
        _ = rangeSlider.map({$0.handleImage = UIImage(named: "rectangle")})
        _ = rangeSlider.map({$0.delegate = self})
        _ = rangeSlider.map({$0.handleDiameter = 40})
        
    }
    
    //MARK: NaviationBar
    func configureFiltersNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.dropBottomShadow(color: UIColor(red: 74/255, green: 105/255, blue: 200/255, alpha: 0.49))
        configureNavigationItems()
    }
    
    func configureNavigationItems() {
        self.navigationItem.title = "Filters"
        
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBarButtonAction))
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBarButtonAction))
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont(name: "CircularStd-Bold", size: 12.0)!]
        leftBarButtonItem.setTitleTextAttributes(fontAttributes, for: .normal)
        rightBarButtonItem.setTitleTextAttributes(fontAttributes, for: .normal)
        
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.init(r: 148, g: 162, b: 188)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.init(r: 74, g: 105, b: 200)
    }
    
    func configureStatusBar(with color: UIColor) {
        (UIApplication.shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = color
    }
    
    //MARK: TableView
    func configureFiltersTableView() {
        filtersTableView.dataSource = self
        filtersTableView.delegate = self
        filtersTableView.separatorColor = .white
    }
    
    func getFilterDetails() {
        FiltersViewModel.shared.getPreviousFilterDetails { (status, filterDetails, errorMessage) in
            if status {
                self.filter = filterDetails
                self.placeHolderValues = FiltersViewModel.shared.placeHolderValues
                var index = 0
                switch filterDetails?.gender {
                case "male":
                    index = 0
                case "female":
                     index = 1
                case "both":
                    index = 2
                default: break
                }
                self.updateRangeSlider()
                self.genderButton[index].sendActions(for: .touchUpInside)
                self.filtersTableView.reloadData()
            } else {
                
            }
        }
    }
    
    func updateRangeSlider() {
        rangeSlider[0].selectedMinimum = Float((Int((filter?.ageMin)!) ?? filter?.minimumAge)!)
        rangeSlider[0].selectedMaximum = Float((Int((filter?.ageMax)!) ?? filter?.maximumAge)!)
        ageRangeLabel.text = filter?.ageRange
        
        rangeSlider[1].selectedMinimum = Float(filter!.heightMin.replacingOccurrences(of: " ", with: ""))! * 12
        rangeSlider[1].selectedMaximum = Float(filter!.heightMax.replacingOccurrences(of: " ", with: ""))! * 12 //Float((Int((filter?.heightMax)!)! * 12))
        heightRangeLabel.text = filter?.heightRange
        
        rangeSlider[2].selectedMaximum = Float(Int((filter?.distanceRange)!) ?? (filter?.maximumDistance)!)
        distanceRangeLabel.text = (filter?.distanceRange)! + " Miles"
    }
    
    @objc func cancelBarButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveBarButtonAction() {
        loader.startAnimaton(message: "")
        FiltersViewModel.shared.saveFilterDetails(with: ageRangeLabel.text!, height: heightRangeLabel.text!, distance: distanceRangeLabel.text!, gender: gender, values: placeHolderValues, filter: filter!) { (status, errorMessage, response) in
            loader.stopAnimaton()
            if status {
                
            } else {
                
            }
        }
    }
    
    @IBAction func genderButtonAction(_ sender: UIButton) {
        for button in (genderView.subviews.first)!.subviews {
            if (button is UIButton) {
                let btn = button as! UIButton
                btn.isSelected = false
                btn.backgroundColor = UIColor.white
                btn.setTitleColor(UIColor(red: 193/255, green: 204/255, blue: 235/255, alpha: 1.0), for: .normal)
            }
        }
        switch sender.tag {
        case 0:
            gender = "male"
        case 1:
            gender = "female"
        case 2:
            gender = "both"
        default:
            gender = ""
        }
        sender.isSelected = true
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.backgroundColor = UIColor(r: 74, g: 105, b: 200)
    }
}
//MARK: TableView Data Souce and Delegate
extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeHolderTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FiltersCell.identifier, for: indexPath) as! FiltersCell
        let placeHolderValue = placeHolderTexts[indexPath.row] // placeHolderValues.count == 0 ? "" : placeHolderValues[indexPath.row]
        cell.delegate = self
        cell.filter = filter
        cell.setCellValues(with: placeHolderValue, value: placeHolderValues[placeHolderValue] as? String ?? "", index: indexPath.row)
        return cell
    }
    
    
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension FiltersViewController: FiltersTableViewCellDelegate {
    func textFieldShouldEndEditing(with text: String, textField: OuterLineTextField) {
//        placeHolderValues.remove(at: textField.tag)
        placeHolderValues[textField.restorationIdentifier!] = text
        self.filtersTableView.reloadData()
    }
}

//MARK: Rangle Slide delegate
extension FiltersViewController: TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        let min = Int(selectedMinimum)
        let max = Int(selectedMaximum)
        switch sender.tag {
        case 1:
            ageRangeLabel.text = "\(min) - \(max)"
        case 2:
            let minValue = "\(min/12)'\(min % 12)"
            let maxValue = "\(max/12)'\(max % 12)"
            heightRangeLabel.text = "\(minValue) - \(maxValue)"
        case 3:
            distanceRangeLabel.text = "\(max) Miles"
        default:
            break
        }
    }
}
