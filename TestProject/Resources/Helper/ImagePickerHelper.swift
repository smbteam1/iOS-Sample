//
//  ImagePickerHelper.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

@objc protocol ImagePickerDelegate {
    
    @objc optional func finishedPickingImage(image: UIImage)
    @objc optional func finishedPickingVideo(videoUrl: NSURL, thumbImage: UIImage)
}


let imagePicker = UIImagePickerController()

enum mediaType: Int {
    case onlyImage = 1
    case onlyVideo
    case allMedia
}

class ImagePickerHelper: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
    var viewController: UIViewController!
    var delegate: ImagePickerDelegate!
    var picker: ImagePickerHelper!
    var isEditing: Bool!
    
    init(viewController:UIViewController) {
        self.viewController = viewController
        super.init()
        picker = self
    }
    
    //MARK:- Media Selection
    
    func showCamera(withMediaType: mediaType, allowsEditing: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera) {
            imagePicker.modalPresentationStyle = .overCurrentContext
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerController.SourceType.camera
            switch withMediaType {
            case .onlyImage:
                imagePicker.mediaTypes = [kUTTypeImage as String]
            case .onlyVideo:
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.videoMaximumDuration = 30
                imagePicker.videoQuality = .typeMedium
            case .allMedia:
                imagePicker.mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
                imagePicker.videoMaximumDuration = 45
                imagePicker.videoQuality = .typeMedium
            }
            if allowsEditing {
                imagePicker.allowsEditing = true
                isEditing = true
            } else {
                imagePicker.allowsEditing = false
                isEditing = false
            }
            viewController.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func useCameraRoll(withMediaType: mediaType, allowsEditing: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.savedPhotosAlbum) {
            imagePicker.modalPresentationStyle = .overCurrentContext
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            switch withMediaType {
            case .onlyImage:
                imagePicker.mediaTypes = [kUTTypeImage as String]
            case .onlyVideo:
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.videoMaximumDuration = 45
                imagePicker.videoQuality = .typeMedium
            case .allMedia:
                imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
                imagePicker.videoMaximumDuration = 45
                imagePicker.videoQuality = .typeMedium
            }
            if allowsEditing {
                imagePicker.allowsEditing = true
                isEditing = true
            } else {
                imagePicker.allowsEditing = false
                isEditing = false
            }
            viewController.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            var imagePicked: UIImage?
            if isEditing {
                imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            } else {
                imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            }
            imagePicked = UIImage.scaleImageWithDivisor(img: imagePicked!, divisor: 3)
            delegate.finishedPickingImage!(image: imagePicked!)
            self.viewController.dismiss(animated: true, completion: nil)
        } else if mediaType.isEqual(to: kUTTypeMovie as String) {
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! NSURL
            let thumbImage = self.createThumbImage(videoUrl: videoURL)
            delegate.finishedPickingVideo!(videoUrl: videoURL, thumbImage: thumbImage)
            self.viewController.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Create thumbnail
    
    func createThumbImage(videoUrl: NSURL) -> (UIImage) {
        do {
            let asset = AVURLAsset(url: videoUrl as URL, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            var thumbnail = UIImage(cgImage: cgImage)
            let width = thumbnail.size.width
            let height = thumbnail.size.height
            if width > height {
                let imageView = UIImageView()
                imageView.image = thumbnail
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                thumbnail = imageView.image!
            }
            return (thumbnail)
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return (#imageLiteral(resourceName: "defaultimg"))
        }
    }
}

extension UIImage {
    class func scaleImageWithDivisor(img: UIImage, divisor: CGFloat) -> UIImage {
        let size = CGSize(width: img.size.width/divisor, height: img.size.height/divisor)
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
