//
//  NSData+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation

public extension NSData{
    func jsonObject()->NSDictionary?{
        do{
            return try JSONSerialization.jsonObject(with: self as Data, options: .mutableContainers) as AnyObject as? NSDictionary
        }catch let error as NSError {
            print(error)
        }
        return nil
    }
}
