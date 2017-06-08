//
//  PHPhotoLibrary+Permissions.swift
//  Jobok
//
//  Created by Богдан Маншилин on 08/06/2017.
//  Copyright © 2017 Jobok. All rights reserved.
//

import Photos

enum PermissionError: Error {
    case accessDenied
}

extension PHPhotoLibrary {
    
    static func executeIfPermitted(_ exec: @escaping ()->Void) throws {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: exec()
        case .denied, .restricted : throw PermissionError.accessDenied
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized: exec()
                case .denied, .restricted: debugPrint("Access denied")
                case .notDetermined: debugPrint("Access denied")
                }
            }
        }

    }
    
}
