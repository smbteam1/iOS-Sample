//
//  WelcomeProfile.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/29/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit

class WelcomeProfile: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var dobField: OuterLineTextField!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var dobPickerView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var searchGenderView: UIView!
    @IBOutlet weak var questionTbl: UITableView!
    @IBOutlet weak var questionTblHeight: NSLayoutConstraint!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var lblUploadProgress: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressView: UIView!
    
    //MARK:- Objects
    let profileViewModel = ProfileViewModel()
    var questions = [ProfileModel]()
    var gender = ""
    var searchGender = ""
    var imageArr: [UIImage]  = []
    var uploadImageArr: [NSDictionary]  = []
    var selectedAnswerArr: [String]  = []
    var imageUploadSuccessCount = 0
    var fbProfilePic = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    override func viewDidLayoutSubviews() {
        loadViewIfNeeded()
        questionTblHeight.constant = questionTbl.contentSize.height
        self.updateViewConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        dobField.configureSubViews()
        self.imageCollection.reloadData()
    }
    
    //MARK: Date picker value change
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        let date = dateFormatterGet.date(from: dateFormatterGet.string(from: sender.date))
        dobField.text = dateFormatterPrint.string(from: date!)
    }
    
    //MARK: Other functions
    func uploadToAmazonS3(image:UIImage){
        if imageUploadSuccessCount != imageArr.count - 1 {
            let s3Upload = S3Uploader()
            s3Upload.delegate = self
            let fileInfo = s3Upload.createFileNameContentType(mediaType: .ImagePNG)
            if let data:Data = image.pngData() {
                s3Upload.uploadToS3(file: data, fileName: fileInfo[0], contentType: fileInfo[1])
            }
        }
    }

    @IBAction func saveWelcomeProfile() {
        if (dobField.text?.count)! > 0 {
            if gender != "" {
                if searchGender != "" {
                    if imageArr.count > 1 {
                        self.uploadToAmazonS3(image: imageArr[0])
                    }else {
                        AlertHelper().showGSMessage(message: imageLimitMininumAlert, viewC: self, type: 0)
                    }
                }else {
                    AlertHelper().showGSMessage(message: searchGenderAlert, viewC: self, type: 0)
                }
            }else {
                AlertHelper().showGSMessage(message: genderAlert, viewC: self, type: 0)
            }
        }else {
            AlertHelper().showGSMessage(message: dateOfBirthAlert, viewC: self, type: 0)
        }
    }

    func saveWelcomeProfileData() {
        //if imageUploadSuccessCount == imageArr.count - 1 {
            if selectedAnswerArr.count == questions.count {
                
                var answers: [NSDictionary] = []
                for ans in questions {
                    answers.append(["answer": ans.selected_answer,"question_id": ans.question_id]  as NSDictionary)
                }
                let keys:[String: Any] = [
                    "appkey": "TestProject",
                    "dob": dobField.text!,
                    "gender": gender,
                    "looking_for": searchGender,
                    "media": getStringFromJsonArray(Array: uploadImageArr),
                    "answers": getStringFromJsonArray(Array: answers)
                ]
                profileViewModel.saveProfile(param: keys, function_name: "user_profile", onSuccess:{success, message in
                    self.performSegue(withIdentifier: "tabBarVC", sender: self)
                }, onFailure: {failure in
                    loader.stopAnimaton()
                    AlertHelper().showAlertOnCurrentVC(title: "Access Denied", message: failure, btnTitle: "OK") {
                    }
                })
            }else {
                AlertHelper().showGSMessage(message: answerAlert, viewC: self, type: 0)
            }
        //}
        
        
    }
    func initialSetUp() {
        self.getQuestions()
        self.imageArr.append(UIImage.init(named: "add_image")!)
        if self.fbProfilePic != "" {
            if let data = try? Data(contentsOf: URL(string: self.fbProfilePic)!)
            {
                let image: UIImage = UIImage(data: data)!
                imageArr.insert(image, at: imageArr.count - 1)
            }
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        components.year = -19
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        components.year = -150
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        dobPicker.minimumDate = minDate
        dobPicker.maximumDate = maxDate
        
        self.dobField.inputView = self.dobPickerView
        self.dobPicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    func getQuestions() {
        loader.startAnimaton(message: "")
        let keys:[String: String] = [:]
        profileViewModel.profileRequest(param: keys, function_name: "get_questions", onSuccess:{success, message in
            loader.stopAnimaton()
            self.questions = self.profileViewModel.questionsModelArr
            self.questionTbl.reloadData()
            self.viewDidLayoutSubviews()
        }, onFailure: {failure in
            loader.stopAnimaton()
            AlertHelper().showAlertOnCurrentVC(title: "Access Denied", message: failure, btnTitle: "OK") {
            }
        })
    }
    @IBAction func selectGender(_ sender: UIButton) {
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
            gender = "other"
        default:
            gender = ""
        }
        sender.isSelected = true
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.backgroundColor = UIColor(red: 74/255, green: 105/255, blue: 200/255, alpha: 1.0)
    }
    @IBAction func selectSearchGender(_ sender: UIButton) {
        for button in (searchGenderView.subviews.first)!.subviews {
            if (button is UIButton) {
                let btn = button as! UIButton
                btn.isSelected = false
                btn.backgroundColor = UIColor.white
                btn.setTitleColor(UIColor(red: 193/255, green: 204/255, blue: 235/255, alpha: 1.0), for: .normal)
            }
        }
        switch sender.tag {
        case 0:
            searchGender = "male"
        case 1:
            searchGender = "female"
        case 2:
            searchGender = "other"
        default:
            searchGender = ""
        }
        sender.isSelected = true
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.backgroundColor = UIColor(red: 74/255, green: 105/255, blue: 200/255, alpha: 1.0)
    }
    

}
//MARK:- Table view extension
extension WelcomeProfile : UITableViewDelegate,UITableViewDataSource{
    
    func getQuestionDetails(curIndx: Int) -> (ProfileModel) {
        return (questions[curIndx])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "QuestionCell") as! QuestionCell
        let data = self.getQuestionDetails(curIndx: section)
        headerView.questionLbl.text = data.question
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = self.getQuestionDetails(curIndx: section)
        return data.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
        let data = self.getQuestionDetails(curIndx: indexPath.section)
        cell.answerTitleLbl.text = data.answers[indexPath.row].title
        cell.answerLbl.text = data.answers[indexPath.row].answer
        if data.selected_answer != "" && data.answers[indexPath.row].option == data.selected_answer {
            cell.selectBtn.isSelected = true
        }else {
            cell.selectBtn.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.getQuestionDetails(curIndx: indexPath.section)
        if selectedAnswerArr.contains(data.question_id) {
        
        }else {
            selectedAnswerArr.append(data.question_id)
        }
        self.profileViewModel.setSelectedAnswer(fieldVal: data.answers[indexPath.row].option, arrIndx: indexPath.section)
        questionTbl.reloadData()
    }
}

//MARK:- Image picker
extension WelcomeProfile: ImagePickerDelegate {
    @objc func imagePickActionSheet(sender: UIButton){
        
        if imageArr.count < 6 {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
                self.presentCamera(type: .onlyImage)
                print("Camera Clicked")
            }))
            
            alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default , handler:{ (UIAlertAction)in
                self.presentPhotoLibrary()
                print("Photo Library Clicked")
            }))
            
           /* alert.addAction(UIAlertAction(title: "Record Video", style: .default , handler:{ (UIAlertAction)in
                self.presentCamera(type: .onlyVideo)
                print("Camera Clicked")
            }))
            
            alert.addAction(UIAlertAction(title: "Video Gallery", style: .default , handler:{ (UIAlertAction)in
                self.presentPhotoLibrary()
                print("Photo Library Clicked")
            }))*/
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Cancel button")
            }))
            
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = sender.frame
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        }else {
            AlertHelper().showGSMessage(message: imageLimitExceedAlert, viewC: self, type: 1)
        }
    }
    
    func presentCamera(type: mediaType){
        
        let imagePicker = ImagePickerHelper(viewController: self)
        imagePicker.delegate = self
        imagePicker.showCamera(withMediaType: type, allowsEditing: true)
        
    }
    
    func presentPhotoLibrary(){
        
        let imagePicker = ImagePickerHelper(viewController: self)
        imagePicker.delegate = self
        imagePicker.useCameraRoll(withMediaType: .onlyImage, allowsEditing: true)
        
    }
    
    func finishedPickingImage(image: UIImage) {
        imageArr.insert(image, at: imageArr.count - 1)
        imageCollection.reloadData()
        let item = self.collectionView(self.imageCollection!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = NSIndexPath(item: item, section: 0)
        self.imageCollection?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionView.ScrollPosition.right, animated: false)
    }
    
    func finishedPickingVideo(videoUrl: NSURL, thumbImage: UIImage) {
        
    }
}

//MARK:- Collection view delegates
extension WelcomeProfile: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @objc func deleteImages(sender: UIButton) {
        imageArr.remove(at: sender.tag)
        imageCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomeImageCell", for: indexPath) as! WelcomeImageCell

        Cell.welcomeImg.image = imageArr[indexPath.row]
        if indexPath.row == imageArr.count - 1 {
            Cell.deleteImgBtn.isHidden = true
            Cell.addImgBtn.isHidden = false
            Cell.addImgBtn.addTarget(self, action: #selector(imagePickActionSheet(sender:)), for: .touchUpInside)
        }else {
            Cell.addImgBtn.isHidden = true
            Cell.addImgBtn.removeTarget(self, action: nil, for: .allEvents)
            Cell.deleteImgBtn.isHidden = false
            Cell.deleteImgBtn.tag = indexPath.row
            Cell.deleteImgBtn.addTarget(self, action: #selector(deleteImages(sender:)), for: .touchUpInside)
        }
        return Cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK:- TextField: UITextField
extension UITextField: OuterLineTextFieldDelegate {
    func textFieldShouldReturn(with textField: OuterLineTextField) {
        
    }
    
    func textFieldShouldBeginEditing(with textField: OuterLineTextField) {
        
    }
    
    func textFieldShouldEndEditing(with textField: OuterLineTextField) {
        
    }

    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        //return action == #selector(UIResponderStandardEditActions.cut) || action == #selector(UIResponderStandardEditActions.copy)
        return false
    }
}

//MARK:- S3 upload for image and video
extension WelcomeProfile: S3UploadDelegate {
    
    func s3UploadResponse(fileName: String) {
        print("Uploaded successfully")
        let arr = ["name": fileName, "type": "image"]
        uploadImageArr.append(arr as NSDictionary)        
        if imageUploadSuccessCount < imageArr.count - 2 {
            imageUploadSuccessCount += 1
            self.uploadToAmazonS3(image: imageArr[imageUploadSuccessCount])
        }else {
            progressView.isHidden = true
            self.lblUploadProgress.text = "Uploading Image..."
            self.progressBar.progress = 0.0
            self.saveWelcomeProfileData()
        }
    }
    
    func s3UploadProgress(progress: Double) {
        /*let percentage = 100.0 * progress
        self.lblUploadProgress.text = "Uploading Image \(imageUploadSuccessCount)/\(imageArr.count - 1).. \(Int(percentage))%"
        self.progressView.isHidden = false
        self.progressBar.progress = Float(progress)*/
        //let percentage = 100.0 * (Double)(imageUploadSuccessCount / imageArr.count)
        self.lblUploadProgress.text = "Uploading Image \(imageUploadSuccessCount+1)/\(imageArr.count - 1)"
        self.progressView.isHidden = false
        self.progressBar.progress = Float(imageUploadSuccessCount+1) / Float(imageArr.count - 1)
    }
    
    func s3UploadError(errorString: String) {
        if errorString != "" {
            imageUploadSuccessCount = 0
            AlertHelper().showToast(message: imageUploadAlert)
            self.lblUploadProgress.text = "Uploading Image..."
            self.progressBar.progress = 0.0
            uploadImageArr.removeAll()
            self.uploadToAmazonS3(image: imageArr[0])
            print("Uploaded Error \(errorString)")
        }
    }
}
