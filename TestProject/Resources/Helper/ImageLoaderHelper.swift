//
//  ImageLoaderHelper.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 15/05/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import Foundation
import Kingfisher
import AVKit
import AVFoundation


func loadImage(fromUrl: String, imageView: UIImageView) {
    let urlImage = URL(string: fromUrl)
    let imageView = imageView
    guard (urlImage) != nil else {
        print("Error: cannot create URL")
        return
    }
    imageView.kf.indicatorType = .activity
    imageView.kf.setImage(with: urlImage, placeholder: imageView.image, options: [.transition(.none)])
}

func loadImageWithPaceholder(fromUrl: String,placeHolderUrl:String, imageView: UIImageView) {
    let placeHolderimage = URL(string: fromUrl)
    guard (placeHolderimage) != nil else {
        print("Error: cannot create URL")
        return
    }
    let imageView = imageView
    imageView.kf.indicatorType = .activity
}


func loadImage(withPlaceholder: UIImage, fromUrl: URL, imageView: UIImageView) {
    let imageView = imageView
    imageView.kf.indicatorType = .activity
    imageView.kf.setImage(with: fromUrl, placeholder: withPlaceholder, options: [.transition(ImageTransition.fade(1))])
}
