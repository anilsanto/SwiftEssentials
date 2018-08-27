//
//  NSDictionary+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation

public extension NSDictionary {
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
    
    class func fetchDataFormBundle(filename : String,exten:String)->NSDictionary{
        var array : NSDictionary?
        let path = Bundle.main.path(forResource: filename, ofType: exten)
        let airportString = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        let data: NSData = airportString!.data(using: String.Encoding.utf8)! as NSData
        do{
            array = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? NSDictionary
        }catch let error as NSError {
            print(error)
            array = [:]
        }
        return array!
    }
    
    class func fetchDataSetFormBundle(filename : String,exten:String)->[NSDictionary]{
        var array : [NSDictionary]?
        let path = Bundle.main.path(forResource: filename, ofType: exten)
        let airportString = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        let data: NSData = airportString!.data(using: String.Encoding.utf8)! as NSData
        do{
            array = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? [NSDictionary]
        }catch let error as NSError {
            print(error)
            array = []
        }
        return array!
    }
}
