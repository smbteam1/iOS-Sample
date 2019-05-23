//
//  LocationHelper.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 9/5/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit
import CoreLocation

class LocationHelper: NSObject {

    var locationManager: CLLocationManager!
    var currentLocation: CLLocation! {
        didSet {
            currentLatitude = String(currentLocation.coordinate.latitude)
            currentLongitude = String(currentLocation.coordinate.longitude)
        }
    }
    
    static let sharedInstance : LocationHelper = {
        let instance = LocationHelper()
        return instance
    }()
    
    func initialiseManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
    }
    private func getLocation() {
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            getLocation()
            break
        case .denied:
            AlertHelper().showAlertOnCurrentVC(title: "Location Access Denied", message: "App require access to get your current location. Please goto your phone settings and enable the access for this app.", btnTitle: "OK") {
                
            }
            break
        case .notDetermined:
            break
        default:
            AlertHelper().showAlertOnCurrentVC(title: "Location Error", message: "Cannot access your current location. Please goto your phone settings and verify if the access is allowed for this app.", btnTitle: "OK") {
                
            }
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if locations.count > 0 {
            print("Current Location...", locations.last!)
            currentLocation = locations.last
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Location"), object: nil)
        } else {
            AlertHelper().showAlertOnCurrentVC(title: "Location Error", message: "Cannot find your current location", btnTitle: "Retry", completion: {
                self.getLocation()
            })
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        AlertHelper().showAlertOnCurrentVC(title: "Location Error", message: error.localizedDescription, btnTitle: "OK", completion: {

        })
    }
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print(error?.localizedDescription as Any)
    }
}
