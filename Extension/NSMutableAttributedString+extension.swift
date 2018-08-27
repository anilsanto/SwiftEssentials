//
//  NSMutableAttributedString+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    @discardableResult func attribute(_ text:String,needUnderline : Bool = false,font : UIFont?,color : UIColor?)->NSMutableAttributedString {
        
        var attrs:[NSAttributedStringKey:Any] = [:]
        if font != nil{
            attrs.updateValue(font!, forKey: NSAttributedStringKey.font)
        }
        if color != nil{
            attrs.updateValue(color!, forKey: NSAttributedStringKey.foregroundColor)
        }
        if needUnderline == true{
            attrs.updateValue(NSUnderlineStyle.styleSingle.rawValue as AnyObject, forKey: NSAttributedStringKey.underlineStyle)
        }
        let string = NSMutableAttributedString(string: text, attributes:attrs)
        self.append(string)
        return self
    }
}
