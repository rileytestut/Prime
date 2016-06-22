//
//  PreviewView.swift
//  Prime
//
//  Created by Riley Testut on 5/13/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

import UIKit
import AVFoundation

public extension PreviewView
{
    enum VideoGravity
    {
        case resize
        case resizeAspect
        case resizeAspectFill
        
        public var layerVideoGravity: String {
            switch self
            {
            case .resize: return AVLayerVideoGravityResize
            case .resizeAspect: return AVLayerVideoGravityResizeAspect
            case .resizeAspectFill: return AVLayerVideoGravityResizeAspectFill
            }
        }
        
        public init?(layerVideoGravity: String)
        {
            switch layerVideoGravity
            {
            case AVLayerVideoGravityResize: self = .resize
            case AVLayerVideoGravityResizeAspect: self = .resizeAspect
            case AVLayerVideoGravityResizeAspectFill: self = .resizeAspectFill
            default: return nil
            }
        }
    }
}

public class PreviewView: UIView
{
    public var videoGravity = VideoGravity.resizeAspect {
        didSet {
            self.previewLayer?.videoGravity = self.videoGravity.layerVideoGravity
        }
    }
    
    internal let previewLayer = AVCaptureVideoPreviewLayer(session: nil)
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.prepare()
        
        // Only set default background color when initializing from code, not Interface Builder
        self.backgroundColor = UIColor.black()
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.prepare()
    }
}

public extension PreviewView
{
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.previewLayer?.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
}

private extension PreviewView
{
    func prepare()
    {
        self.previewLayer?.videoGravity = self.videoGravity.layerVideoGravity
        self.layer.addSublayer(self.previewLayer!)
    }
}
