//
//  ExtensionsHelper.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 4/18/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var borderWidth:Float{
        get{
            return Float(self.layer.borderWidth)
        }
        set{
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    @IBInspectable var borderColor:UIColor{
        get{
            if let color = self.layer.borderColor{
                return UIColor(cgColor: color)
            }else{
                return UIColor.clear
            }
        }
        set{
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    func dropShadow(width: CGFloat, height: CGFloat, color: UIColor) {
        let shadowSize : CGFloat = 3.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: width + shadowSize,
                                                   height: height + shadowSize))
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.7
        layer.shadowPath = shadowPath.cgPath
    }
    func dropBottomShadow(color: UIColor) {
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3.0
        layer.shadowColor = color.cgColor
    }
    func setRadiusWithShadow(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
    func roundCornersWithLayerMask(cornerRadii: CGFloat, corners: UIRectCorner,bound:CGRect) {
        let path = UIBezierPath(roundedRect: bound,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    func curveCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    func setBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
    }
}

extension String {
    var encodeEmoji: String {
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
    var decodeEmoji: String {
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
    func notEmpty(count: Int) -> Bool {
        return (self.trimmingCharacters(in: .whitespacesAndNewlines).count > count) ? true : false
    }
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Float.pi) / 180.0
    }
}

extension UISearchBar {
    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                textField.textColor = newValue
            }
        }
    }
}

extension Date {
    func setDateBefore(years: Int) -> Date {
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = years
        let minDate = calendar.date(byAdding: dateComponents, to: self)
        return minDate ?? self
    }
}

