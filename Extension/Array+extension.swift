//
//  Array+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation

//extension NSMutableArray{
//    @objc override func findObjects(key : String,value : String)->NSArray?{
//        let predicate = NSPredicate(format: "%@ LIKE %@" ,key,value)
//        return self.filter { predicate.evaluate(with: $0) } as NSArray
//    }
//
//    func getItems(tillIndex : Int)->NSMutableArray{
//        let array = NSMutableArray()
//        for i in 0..<tillIndex{
//            array.add(self.object(at: i))
//        }
//        return array
//    }
//}


extension NSArray{
    func findObjects(key : String,value : String)->NSArray?{
        let predicate = NSPredicate(format: "%@ LIKE %@" ,key,value)
        return self.filter { predicate.evaluate(with: $0) } as NSArray
    }
    
    func getValue(forKey key: String)->[Any]{
        let values = NSMutableArray()
        for item in self{
            values.add((item as! NSDictionary).object(forKey: key) ?? "")
        }
        return values as! [Any]
    }
}

//extension [NSDictionary]{
//    func findObjects(forKey key : String,withValue value : String)->[NSDictionary]?{
//        return self.
//    }
//}
