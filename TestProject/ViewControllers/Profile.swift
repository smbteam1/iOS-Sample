//
//  Profile.swift
//  TestProject
//
//  Created by NewagesMB on 10/05/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit

class Profile: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var paging: UIPageControl!
    @IBOutlet weak var profileTbl: UITableView!
    @IBOutlet weak var profileTblHeight: NSLayoutConstraint!
    @IBOutlet weak var nameAge: UILabel!
    @IBOutlet weak var location: UILabel!

    
    //MARK:- Objects
    let profileViewModel = ProfileViewModel()
    var profile = ProfileModel()
    var imgCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        paging.hidesForSinglePage = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getProfile()
    }
    
    //MARK: Other functions
    func getProfile() {
        loader.startAnimaton(message: "")
        let keys:[String: String] = ["user_id": usermodelObj.user_id]
        profileViewModel.profileRequest(param: keys, function_name: "get_user_profile", onSuccess:{success, message in
            loader.stopAnimaton()
            self.profile = self.profileViewModel.profileModel
            self.nameAge.text = self.profile.first_name + ", " + String(self.profile.age)
            self.location.text = self.profile.current_location
            self.imgCount = self.profile.media.count
            self.paging.numberOfPages = self.imgCount
            self.imageCollection.reloadData()
            self.profileTbl.reloadData()
        }, onFailure: {failure in
            loader.stopAnimaton()
            AlertHelper().showAlertOnCurrentVC(title: "Access Denied", message: failure, btnTitle: "OK") {
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileEdit" {
            let controller = segue.destination as? ProfileEditViewController
            controller?.profile = profile
        }
    }

}

//MARK:- Collection view delegates
extension Profile: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CommonClass().screenSize.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
        
        loadImage(fromUrl: profile.media[indexPath.row].url, imageView: Cell.profileImg)
        return Cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.paging.currentPage = Int(pageNumber)
    }
}

//MARK:- Table view extension
extension Profile : UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
        let logoutCell = tableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath)
        var title = ""
        var value = ""
        switch indexPath.row {
        case 0:
            title = "ABOUT ME"
            value = profile.about
        case 1:
            title = "2 TRUTHS & A LIE"
            value = profile.truth_lie
        case 2:
            title = "PLACE OF BIRTH"
            value = profile.place_birth
        case 3:
            title = "RAISED IN"
            value = profile.raised_in
        case 4:
            title = "HEIGHT"
            value = profile.height
        case 5:
            title = "RELIGION"
            value = profile.religion
        case 6:
            title = "CAREER"
            value = profile.career
        case 7:
            title = "EDUCATION"
            value = profile.education
        case 8:
            title = "DIET"
            value = profile.diet
        case 9:
            title = "ALCOHOL"
            value = profile.alcohol
        case 10:
            title = "SMOKE"
            value = profile.smoke
        case 11:
            title = "KIDS"
            value = profile.kid
        case 12:
            title = "PETS"
            value = profile.pet
        case 13:
            return logoutCell
        default:
            title = ""
            value = ""
        }
        
        cell.answerTitleLbl.text = title
        cell.answerLbl.text = value.isEmpty ? "--" : value
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 13 {
            AlertHelper().logoutAlert(viewC: self, completion: {logout in
                if logout {
                    let keys:[String: String] = ["user_id": usermodelObj.user_id]
                    self.profileViewModel.profileSetting(param: keys, function_name: "logout", onSuccess:{success, message in
                        UserDefaults.standard.set(nil, forKey: "RefreshToken")
                        UserDefaults.standard.set(nil, forKey: "AuthToken")
                        UserDefaults.standard.set(nil, forKey: "username")
                        UserDefaults.standard.set(nil, forKey: "password")
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is Login {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                    }, onFailure: {failure in
                        loader.stopAnimaton()
                        AlertHelper().showAlertOnCurrentVC(title: "Access Denied", message: failure, btnTitle: "OK") {
                        }
                    })
                }
            })
        }
    }
    
}
