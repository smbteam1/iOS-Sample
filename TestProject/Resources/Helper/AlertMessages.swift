//
//  AlertMessages.swift
//  GogoWashWasher
//
//  Created by NewAgeSMB/ijas on 12/11/18.
//  Copyright © 2018 NewAgeSMB. All rights reserved.
//

import Foundation

// MARK: AlertMessage
struct AlertMessage {
    static let Ok = "Ok"
    static let Cancel = "Cancel"
    static let Done = "Done"
    static let Sorry = "Sorry"
    static let locationServiceDisabledTitle = "Location Service Disabled"
    static let locationServiceDisabledMessage = "Enable location service from privacy settings to access location"
    static let permissionNotGrantedTitle = "Permission not granted"
    static let permissionNotGrantedMessage = "Enable location access from setting to access location"
    
    static let enterEmail = "Enter Email"
    static let enterValidEmail = "Enter valid Email"
    static let enterPassword = "Enter Password"
    static let enterValidPassword = "Password should be minimum of 6 digits"
    static let enterFirstName = "Enter first name"
    static let enterLastName = "Enter last name"
    static let retypePassword = "Please re-type the password"
    static let passwordMisMatch = "Passwords dont match"
    static let enterPhone = "Enter mobile number"
    static let enterValidPhone = "Enter valid mobile number"
    static let numberShouldBe10Digits = "Mobile number should be 10 digits"
    static let acceptTerms = "Accept terms and conditions to continue"
    static let enterSsnNumber = "Enter SSN Number"
    static let enterOTP = "Enter OTP to continue"
    static let otpHasSent = "OTP has been sent to "
    static let enterOTPtoProceed = "Enter OTP to proceed"
    static let timePickerTitle = "Choose your time"
    static let chooseLicence = "Choose license image"
    static let chooseInsurance = "Choose insurance image"
    static let enterMobileNumberToResetPassword = "Enter mobile number to reset \n your password"
    static let enterNewMobileNumber = "Enter your new mobile number"
    
    static let uploadingLicense = "Uploading License"
    static let uploadingInsurance = "Uploading Insurance"
    static let errorUploadingDocument = "Error occured while uploading document"
    static let documentChangedSuccessfully = "Document changed successfully"
    
    static let enterCurrentPassword = "Enter current password"
    static let incorrectCurrentPassword = "Incorrect current password"
    static let enterNewPassword = "Enter new password"
    static let enterConfirmPassword = "Enter confirm password"
    static let confirmPasswordIncorrect = "Confirm password dont match"
    
    static let somethingWentWrong = "Something went wrong while fetching data"
    static let networkError = "Network error occured while connecting"
}
