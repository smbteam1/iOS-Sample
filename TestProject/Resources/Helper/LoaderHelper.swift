//
//  LoaderHelper.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActivityHelper: NSObject {
    
    let size: CGFloat = 65.0
    var activityIndicator: NVActivityIndicatorView! = nil
    var overlay: UIView! = nil
    var messageLabel: UILabel!
    let superView: UIView!
    var progress : UIProgressView! = UIProgressView()
    override init() {
        superView = UIApplication.shared.keyWindow
        self.overlay = UIView(frame: CGRect(x:0, y:0, width:superView.frame.size.width, height:superView.frame.size.height))
        self.overlay.backgroundColor = UIColor .black
        self.overlay.alpha = 0.5
        let activityframe = CGRect(x:superView.frame.size.width/2-(size/2), y:superView.frame.size.height/2-(size/2), width:size, height:size)
        self.activityIndicator = NVActivityIndicatorView(frame:activityframe, type: NVActivityIndicatorType.ballClipRotateMultiple, color: UIColor.appGreenColor())
        
        messageLabel = UILabel(frame: CGRect(x: 0, y: activityIndicator.frame.origin.y+activityIndicator.frame.size.height+8, width: superView.frame.size.width, height: 21))
        messageLabel.textAlignment = .center
        messageLabel.text = "Loading..."
        messageLabel.textColor = UIColor .white
        messageLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func startAnimaton(message:String) {
        if message != "" {
            self.messageLabel.text = message
        }
        messageLabel.text = message
        self.superView.addSubview(self.overlay)
        self.superView.addSubview(self.activityIndicator)
        self.superView.addSubview(self.messageLabel)
        activityIndicator.startAnimating()
    }
    
    func startAnimationWithProgressBar(message:String) {
        messageLabel.text = message
        progress = UIProgressView(frame: CGRect(x: 8, y: messageLabel.frame.origin.y + 30, width: self.superView.frame.size.width - 16, height: 10))
        progress.trackTintColor = UIColor.white
        progress.progressTintColor = UIColor(red: 183/255.0 , green: 182/255.0, blue: 12/255.0, alpha: 1.0)
        self.superView.addSubview(self.overlay)
        self.superView.addSubview(self.messageLabel)
        self.superView.addSubview(self.progress)
        self.superView.addSubview(self.activityIndicator)
        activityIndicator.startAnimating()
    }
    func loadProgress(val : Float, message: String) {
        if message.count > 0 {
            messageLabel.text = message
        }
        progress.setProgress(val, animated: true)
    }
    
    func stopAnimaton() {
        self.messageLabel.removeFromSuperview()
        self.overlay.removeFromSuperview()
        if progress != nil {
            progress.removeFromSuperview()
        }
        activityIndicator.stopAnimating()
    }
}
