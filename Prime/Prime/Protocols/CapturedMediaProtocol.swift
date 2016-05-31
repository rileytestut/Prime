//
//  CapturedMediaProtocol.swift
//  Prime
//
//  Created by Riley Testut on 5/31/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

import Foundation
import AVFoundation

public protocol CapturedMediaProtocol { }

extension UIImage: CapturedMediaProtocol { }
extension NSData: CapturedMediaProtocol { }
extension CMSampleBuffer: CapturedMediaProtocol { }