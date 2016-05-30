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
        
        self.cameraController.addPreviewView(self.previewView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapGesture(gestureRecognizer: UITapGestureRecognizer)
    {
        self.cameraController.capturePhoto { (image, error) in
            print(image, error)
        }
    }
    
    override func viewWillAppear(animated: Bool)
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
