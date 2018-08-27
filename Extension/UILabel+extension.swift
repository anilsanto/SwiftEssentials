//
//  UILabel+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    func addImage(imageName: UIImage, afterText bolAfterText: Bool = false){
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = imageName
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if (bolAfterText){
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)
            
            self.attributedText = strLabelText
        }
        else{
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage(){
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
    
}
