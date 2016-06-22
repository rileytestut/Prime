//
//  Result.swift
//  Prime
//
//  Created by Riley Testut on 5/31/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

import Foundation

public enum Result<T, U: ErrorProtocol>
{
    case success(T)
    case failure(U)
}
