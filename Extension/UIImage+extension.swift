//
//  UIImage+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1 )
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func rotateImageBy(degrees: CGFloat) -> UIImage {
        let size = self.size
        UIGraphicsBeginImageContext(size)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat(Double.pi / 180)))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)
        bitmap.draw(self.cgImage!, in: CGRect(origin: origin, size: size))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func image(scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public class func gifImageWithData(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source: source)
    }
    
    public class func gifImageWithURL(gifUrl:String) -> UIImage? {
        guard let bundleURL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        do{
            let imageData = try Data(contentsOf: bundleURL)
            return gifImageWithData(data: imageData)
        }
        catch _ as NSError {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
    }
    
    public class func gifImageWithName(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        do{
            let imageData = try Data(contentsOf: bundleURL)
            return gifImageWithData(data: imageData)
        }
        catch _ as NSError {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
    }
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.05
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties  = (cfProperties as! [String:AnyObject])[kCGImagePropertyGIFDictionary as String]
        var delayObject: AnyObject = (gifProperties as! Dictionary)[kCGImagePropertyGIFUnclampedDelayTime as String]!
        if delayObject.doubleValue == 0 {
            delayObject = (gifProperties as! Dictionary)[kCGImagePropertyGIFDelayTime as String]!
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.05
        }
        
        return delay
    }
    
    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(a: val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(array: delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
}
