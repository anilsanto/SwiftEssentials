//
//  Formatter+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation

extension Formatter {
    var withSeparator: NumberFormatter  {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 3
        formatter.numberStyle = .decimal
        return formatter
    }
}
