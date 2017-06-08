//
//  AVCaptureDevice+Permission.swift
//  Jobok
//
//  Created by Богдан Маншилин on 08/06/2017.
//  Copyright © 2017 Jobok. All rights reserved.
//

import Foundation
import AVFoundation

extension AVCaptureDevice {
    static func executeIfPermitted(_ exec: @escaping ()->Void) throws {
        let cameraMediaType = AVMediaTypeVideo
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied, .restricted: throw PermissionError.accessDenied
        case .authorized: exec()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: cameraMediaType) { granted in
                if granted {
                    exec()
                } else {
                    debugPrint("Denied access to \(cameraMediaType)")
                }
            }
        }
    }
}

