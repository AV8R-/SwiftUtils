//
//  PHPhotoLibrary+Permissions.swift
//  Jobok
//
//  Created by Богдан Маншилин on 08/06/2017.
//  Copyright © 2017 Jobok. All rights reserved.
//

import Photos

extension PHPhotoLibrary {
    
    static func executeIfPermitted(_ exec: @escaping ()->Void, fail: (()->Void)? = nil) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: exec()
        case .denied, .restricted : fail?()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized: exec()
                case .denied, .restricted, .notDetermined: fail?()
                }
            }
        }

    }
    
}
