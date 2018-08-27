//
//  Dictionary+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation

extension Dictionary{
    func jsonData()->NSData?{
        do{
            return try JSONSerialization.data(withJSONObject: self , options: .prettyPrinted) as NSData
        }catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func jsonString()->String?{
        if let data = self.jsonData() {
            if let json = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) {
                return json as String
            }
        }
        return nil
    }
}
