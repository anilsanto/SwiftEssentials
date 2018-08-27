//
//  Float+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation

public extension Float {
    func string(minLimit : Int , maxLimit : Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = minLimit
        formatter.maximumFractionDigits = maxLimit
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
