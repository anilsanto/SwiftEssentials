//
//  Double+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation

extension Double{
    var formattedWithSeparator: String {
        return Formatter().withSeparator.string(for: self) ?? ""
    }
}
