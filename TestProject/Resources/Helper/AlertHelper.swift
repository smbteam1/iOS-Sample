//
//  AlertHelper.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit
import Toaster
import CFAlertViewController
import GSMessages

class AlertHelper: NSObject {

    var alertController: CFAlertViewController!
    
    //MARK:- Toast
    func showToast(message: String) {
        let toast = Toast(text: message)
        toast.duration = 2.0
        toast.show()
    }
    
    //MARK:- Message
    func showGSMessage(message: String, viewC: UIViewController, type: Int) {
        GSMessage.font = UIFont.init(name: CommonClass().fontRegular, size: 8)!
        let gsm = GSMessage(attributedText: NSAttributedString(string: message), type: getMessageType(val: type), options: [.autoHide(true),.hideOnTap(true), .position(.top), .textAlignment(.left), .textColor(.white), .textNumberOfLines(3), .height(38.0)], inView: viewC.view, inViewController: viewC)
        gsm.show()
    }
    func getMessageType(val: Int) -> GSMessageType {
        switch val {
        case 0:
            return .error
        case 1:
            return .info
        case 2:
            return .success
        case 3:
            return .warning
        default:
            return .info
        }
    }
    
    //MARK:- Alert
    func showAlert(title: String, message: String, btnTitle: String, viewC: UIViewController, completion: @escaping ()->()) {
        if alertController != nil {
            if alertController.isBeingPresented {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
        alertController = CFAlertViewController(title: title, message: message, textAlignment: .center, preferredStyle: .alert) { (dismiss) in
            
        }
        alertController.backgroundStyle = .blur
        alertController.backgroundColor = UIColor.clear
        let defaultAction = CFAlertAction(title: btnTitle,
                                          style: .Default,
                                          alignment: .justified,
                                          backgroundColor: UIColor.ssBlue(),
                                          textColor: UIColor.white) { (action) in
                                            completion()
        }
        alertController.addAction(defaultAction)
        viewC.present(alertController, animated: true, completion: nil)
    }
    func showAlertOnCurrentVC(title: String, message: String, btnTitle: String, completion: @escaping ()->()) {
        DispatchQueue.main.async {
            if let nc = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                if let pvc = nc.viewControllers.last {
                    self.showAlert(title: title, message: message, btnTitle: btnTitle, viewC: pvc) {
                        completion()
                    }
                }
            }
        }
    }
    func logoutAlert(viewC: UIViewController, completion: @escaping (_ logout: Bool)->()) {
        let alertController: CFAlertViewController = CFAlertViewController(title: "Logout", message: "Are you sure to logout?", textAlignment: .center, preferredStyle: .alert) { (dismiss) in
            
        }
        alertController.backgroundStyle = .blur
        alertController.backgroundColor = UIColor.clear
        let okAction = CFAlertAction(title: "Yes",
                                          style: .Default,
                                          alignment: .justified,
                                          backgroundColor: UIColor.ssBlue(),
                                          textColor: UIColor.white) { (action) in
                                            completion(true)
        }
        alertController.addAction(okAction)
        let cancel = CFAlertAction(title: "No",
                                   style: .Default,
                                   alignment: .justified,
                                   backgroundColor: UIColor.appGrayTextColor(),
                                   textColor: UIColor.white) { (action) in
                                    completion(false)
        }
        alertController.addAction(cancel)
        viewC.present(alertController, animated: true, completion: nil)
    }
    func showMessageAlert(viewC: UIViewController, title: String, message: String, completion: @escaping (_ status: Bool)->()) {
        let alertController: CFAlertViewController = CFAlertViewController(title: title, message: message, textAlignment: .center, preferredStyle: .alert) { (dismiss) in
            
        }
        alertController.backgroundStyle = .blur
        alertController.backgroundColor = UIColor.clear
        let okAction = CFAlertAction(title: "Yes",
                                     style: .Default,
                                     alignment: .justified,
                                     backgroundColor: UIColor.ssBlue(),
                                     textColor: UIColor.white) { (action) in
                                        completion(true)
        }
        alertController.addAction(okAction)
        let cancel = CFAlertAction(title: "No",
                                   style: .Default,
                                   alignment: .justified,
                                   backgroundColor: UIColor.ssGreen(),
                                   textColor: UIColor.white) { (action) in
                                    completion(false)
        }
        alertController.addAction(cancel)
        viewC.present(alertController, animated: true, completion: nil)
    }
    
    
}
