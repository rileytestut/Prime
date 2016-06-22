//
//  ViewController.swift
//  Demo
//
//  Created by Riley Testut on 5/13/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

import UIKit
import AVFoundation

import Prime

class ViewController: UIViewController
{
    /// Cameras
    private let cameraController = CameraController(sessionPreset: AVCaptureSessionPresetHigh)
    
    /// UI
    @IBOutlet private var previewView: PreviewView!
    
    /// Configuration
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
}

extension ViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.cameraController.add(self.previewView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPressGesture(_:)))
        self.view.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.cameraController.startSession()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

private extension ViewController
{
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer)
    {
        self.cameraController.capturePhoto { (result: UIImageResult) in
            switch result
            {
            case let .success(image): print("Captured image:", image)
            case let .failure(error): print("Failed to capture image with error:", error)
            }
        }
    }
    
    @objc func handleLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
    {
        guard gestureRecognizer.state == .began else { return }
        
        do
        {
            let settings = CameraSettings(focusMode: .autoFocus, exposureMode: .autoExpose, pointOfInterest: CGPoint(x: 0.5, y: 0.5))
            try self.cameraController.apply(settings)
        }
        catch let error as NSError
        {
            print(error)
        }
    }
}
