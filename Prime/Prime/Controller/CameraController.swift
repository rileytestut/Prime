//
//  CameraController.swift
//  Prime
//
//  Created by Riley Testut on 5/13/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

import Foundation
import AVFoundation

public class CameraController
{
    /// State
    public private(set) var running = false
    
    /// Preview
    public private(set) var previewViews = [PreviewView]()
    
    /// AVFoundation
    public let captureSession: AVCaptureSession
    
    /// Cameras
    public var currentCamera: AVCaptureDevice?
    {
        guard let inputs = self.captureSession.inputs as? [AVCaptureDeviceInput] else { return nil }
        
        for input in inputs
        {
            if input.ports.first?.mediaType == AVMediaTypeVideo
            {
                return input.device
            }
        }
        
        return nil
    }
    
    /// Private
    private let sessionQueue = DispatchQueue(label: "com.rileytestut.Prime.CameraController.sessionQueue", attributes: .serial)
    
    private let stillImageOutput = AVCaptureStillImageOutput()
    
    public init(sessionPreset: String, preferredCameraPosition: AVCaptureDevicePosition = .unspecified)
    {
        self.captureSession = AVCaptureSession()
        self.captureSession.sessionPreset = sessionPreset
        
        self.sessionQueue.async {
            
            self.captureSession.beginConfiguration()
            
            let captureDevice: AVCaptureDevice?
            
            switch preferredCameraPosition
            {
            case .front, .back: captureDevice = self.cameraDevice(position: preferredCameraPosition)
            case .unspecified: captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            }
            
            if let captureDevice = captureDevice
            {
                self.addCaptureDevice(captureDevice)
            }
            
            self.captureSession.addOutput(self.stillImageOutput)
            
            self.captureSession.commitConfiguration()
            
        }
        
        
    }
}

/// Session
public extension CameraController
{
    func startSession()
    {
        guard !self.running else { return }
        
        self.sessionQueue.async {
            self.captureSession.startRunning()
            self.running = true
        }
    }
    
    func stopSession()
    {
        guard self.running else { return }
        
        self.sessionQueue.async {
            self.captureSession.stopRunning()
            self.running = false
        }
    }
}

/// Capture Media
public extension CameraController
{
    func capturePhoto(_ completion: (Result<UIImage, NSError>) -> Void)
    {
        self._capturePhoto(completion)
    }
    
    func capturePhoto<T: CapturedMediaProtocol>(_ completion: (Result<T, NSError>) -> Void)
    {
        self._capturePhoto(completion)
    }
    
    private func _capturePhoto<T: CapturedMediaProtocol>(_ completion: (Result<T, NSError>) -> Void)
    {
        precondition(T.self == UIImage.self || T.self == Data.self || T.self == NSData.self || T.self == CMSampleBuffer.self, "Photo must be returned as UIImage, Data, NSData, or CMSampleBuffer")
        
        self.stillImageOutput.captureStillImageAsynchronously(from: self.stillImageOutput.connection(withMediaType: AVMediaTypeVideo)) { (sampleBuffer, error) in
            guard let sampleBuffer = sampleBuffer else {
                completion(.failure(error!))
                return
            }
            
            if let result = sampleBuffer as? T
            {
                completion(.success(result))
                return
            }
            
            let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
            if let result = data as? T
            {
                completion(.success(result))
                return
            }
            
            let image = UIImage(data: data!)
            if let result = image as? T
            {
                completion(.success(result))
                return
            }
        }
    }
}

/// Camera Settings
public extension CameraController
{
    func setCameraSettings(_ settings: CameraSettings) throws
    {
        guard let currentCamera = self.currentCamera else { return }
        
        try currentCamera.lockForConfiguration()
        
        if let focusMode = settings.focusMode where currentCamera.isFocusModeSupported(focusMode)
        {
            if let pointOfInterest = settings.pointOfInterest
            {
                currentCamera.focusPointOfInterest = pointOfInterest
            }
            
            currentCamera.focusMode = focusMode
        }
        
        if let exposureMode = settings.exposureMode where currentCamera.isExposureModeSupported(exposureMode)
        {
            if let pointOfInterest = settings.pointOfInterest
            {
                currentCamera.exposurePointOfInterest = pointOfInterest
            }
            
            currentCamera.exposureMode = exposureMode
        }
        
        if let whiteBalanceMode = settings.whiteBalanceMode where currentCamera.isWhiteBalanceModeSupported(whiteBalanceMode)
        {
            currentCamera.whiteBalanceMode = whiteBalanceMode
        }
        
        currentCamera.unlockForConfiguration()
    }
}

/// Capture Devices
public extension CameraController
{
    func cameraDevice(position: AVCaptureDevicePosition) -> AVCaptureDevice?
    {
        return self.captureDevice(AVMediaTypeVideo, position: position)
    }
    
    private func captureDevice(_ mediaType: String, position: AVCaptureDevicePosition) -> AVCaptureDevice?
    {
        let devices = (AVCaptureDevice.devices(withMediaType: mediaType) as! [AVCaptureDevice]).filter({ $0.position == position })
        return devices.first
    }
}

/// Preview Views
public extension CameraController
{
    func addPreviewView(_ previewView: PreviewView)
    {
        previewView.previewLayer?.session = self.captureSession
        
        self.previewViews.append(previewView)
    }
    
    func removePreviewView(_ previewView: PreviewView)
    {
        guard let index = self.previewViews.index(of: previewView) else { return }
        
        previewView.previewLayer?.session = nil
        
        self.previewViews.remove(at: index)
    }
}

private extension CameraController
{
    func addCaptureDevice(_ captureDevice: AVCaptureDevice) -> Bool
    {
        do
        {
            let videoDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            if self.captureSession.canAddInput(videoDeviceInput)
            {
                self.captureSession.addInput(videoDeviceInput)
                
                return true
            }

        }
        catch let error as NSError
        {
            print(error)
        }
        
        return false
    }
}
