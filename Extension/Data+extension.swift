//
//  Data+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation

extension Data{
    func base64String()->String{
        return self.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    func jsonObject()->NSDictionary?{
        do{
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as AnyObject as? NSDictionary
        }catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func toString() -> String?{
        return String(data: self, encoding: .utf8)
    }
}
