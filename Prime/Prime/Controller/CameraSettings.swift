//
//  CameraSettings.swift
//  Prime
//
//  Created by Riley Testut on 6/11/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

import AVFoundation

public struct CameraSettings
{
    public var focusMode: AVCaptureFocusMode?
    public var exposureMode: AVCaptureExposureMode?
    public var whiteBalanceMode: AVCaptureWhiteBalanceMode?
    
    public var pointOfInterest: CGPoint?
    
    public init(focusMode: AVCaptureFocusMode? = nil, exposureMode: AVCaptureExposureMode? = nil, whiteBalanceMode: AVCaptureWhiteBalanceMode? = nil, pointOfInterest: CGPoint? = nil)
    {
        self.focusMode = focusMode
        self.exposureMode = exposureMode
        self.whiteBalanceMode = whiteBalanceMode
        
        self.pointOfInterest = pointOfInterest
    }
}
