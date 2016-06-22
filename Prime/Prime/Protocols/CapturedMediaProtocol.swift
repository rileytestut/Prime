//
//  CapturedMediaProtocol.swift
//  Prime
//
//  Created by Riley Testut on 5/31/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

import Foundation
import AVFoundation

public protocol CapturedMediaProtocol {}

extension UIImage: CapturedMediaProtocol {}
extension CMSampleBuffer: CapturedMediaProtocol {}
extension Data: CapturedMediaProtocol {}
extension NSData: CapturedMediaProtocol {}

public typealias UIImageResult = Result<UIImage, NSError>
public typealias CMSampleBufferResult = Result<CMSampleBuffer, NSError>
public typealias DataResult = Result<Data, NSError>
public typealias NSDataResult = Result<NSData, NSError>
