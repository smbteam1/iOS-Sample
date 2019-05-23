//
//  S3Uploader.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 06/05/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore

@objc protocol S3UploadDelegate: class {
    @objc optional func s3UploadResponse(fileName: String)
    @objc optional func s3UploadError(errorString: String)
    @objc optional func s3UploadProgress(progress: Double)
}

class S3Uploader: NSObject {
    
    enum MediaTypes {
        case ImagePNG
        case ImageJPEG
        case Video
    }
    
    var delegate: S3UploadDelegate?
    var progressBlock: AWSS3TransferUtilityProgressBlock?
    let transferUtility = AWSS3TransferUtility.default()
    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    let expression = AWSS3TransferUtilityUploadExpression()
    let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast2, identityPoolId: AmazonCredentials.identityPool)
    
    func uploadToS3(file: Data, fileName: String, contentType: String) {
        expression.progressBlock = progressBlock
        var completionHandler1: AWSS3TransferUtilityUploadCompletionHandlerBlock! = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                
                if error != nil {
                    print("Error: \(error!.localizedDescription)")
                }
                self.delegate?.s3UploadResponse!(fileName: fileName)
                print("Upload Success")
            })
        }
        
        AWSServiceManager.default().defaultServiceConfiguration = configure()
        transferUtility.uploadData(
            file,
            bucket: AmazonCredentials.inputBucket,
            key: fileName,
            contentType: contentType,
            expression: expression,
            completionHandler: completionHandler1).continueWith { (task) -> AnyObject? in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                    self.delegate?.s3UploadError!(errorString: error.localizedDescription)
                }
                if let _ = task.result {
                    DispatchQueue.main.async {
                        print("Upload Starting!")
                    }
                }
                return nil;
        }
        
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {

                self.delegate?.s3UploadProgress!(progress: progress.fractionCompleted)
                if progress.isFinished {
                } else if progress.isCancelled {
                    self.delegate?.s3UploadError!(errorString: "Error")
                }
            })
        }
        
        completionHandler1 = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Failed with error: \(error)")
                }
                
                print("Upload Complete")
            })
        }
    }
    
    func configure() -> AWSServiceConfiguration {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2, identityPoolId: AmazonCredentials.identityPool)
        let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider: credentialsProvider)
        return configuration!
    }
    
    func resumeUpload(videoUrlString: String, videoName: String, completion: @escaping (Bool) -> ()) {
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast2, identityPoolId: AmazonCredentials.identityPool)
        let configuration = AWSServiceConfiguration(region: .USEast2, credentialsProvider: credentialProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        print("Uploading media url: \(videoUrlString) \n named: ", videoName)
        let utility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
            })
        }
        
        let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock!
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
        
        if let videoUrl = URL(string: videoUrlString) {
            utility.uploadFile(videoUrl, bucket: AmazonCredentials.inputBucket, key: videoName, contentType: "video/quicktime", expression: expression, completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                }
                
                if let _ = task.result {
                    print("resuming uploading of \(videoName)")
                }
                return nil;
            }
        } else {
            print("couldn't upload the video")
        }
    }
    
    func createFileNameContentType(mediaType: MediaTypes) -> [String] {
        var fileName = usermodelObj.user_id + "-" + ProcessInfo.processInfo.globallyUniqueString
        var contentType = ""
        switch mediaType {
        case .ImageJPEG:
            fileName = fileName + ".jpg"
            contentType = "image/jpeg"
        case .ImagePNG:
            fileName = fileName + ".png"
            contentType = "image/png"
        case .Video:
            fileName = fileName + ".mov"
            contentType = "video/quicktime"
        }
        return [fileName, contentType]
    }
}
