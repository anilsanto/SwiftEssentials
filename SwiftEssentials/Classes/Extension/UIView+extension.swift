//
//  UIView+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func animateFontBlink(withDuration duration: TimeInterval) {
        let oldTransform = transform
        transform = transform.scaledBy(x: 1.1, y: 1.1)
        setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, animations: {
            self.transform = oldTransform
            self.layoutIfNeeded()
        }, completion: { finished in
        })
    }
    
    func addGradiant(sColor : UIColor,eColor : UIColor,sPoint : CGPoint,ePoint : CGPoint){
        let startingColorOfGradient = sColor.cgColor
        let endingColorOFGradient = eColor.cgColor
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.startPoint = sPoint
        gradient.endPoint = ePoint
        gradient.colors = [startingColorOfGradient , endingColorOFGradient]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func captureView()->UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: false )
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
    
    func addShadow(color: UIColor,opacity : Float,radius : Float){
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = CGFloat(radius)
    }
    
//    public struct FZInnerShadowDirection: OptionSet {
//        public let rawValue: Int
//        static let None = FZInnerShadowDirection(rawValue: 0)
//        static let Left = FZInnerShadowDirection(rawValue: 1 << 0)
//        static let Right = FZInnerShadowDirection(rawValue: 1 << 1)
//        static let Top = FZInnerShadowDirection(rawValue: 1 << 2)
//        static let Bottom = FZInnerShadowDirection(rawValue: 1 << 3)
//        static let All = FZInnerShadowDirection(rawValue: 15)
//    }
//
//    func removeInnerShadow() {
//        for view in self.subviews {
//            if (view.tag == 2639) {
//                view.removeFromSuperview()
//                break
//            }
//        }
//    }
//
//    func addInnerShadow() {
//        let c = UIColor()
//        let color = c.withAlphaComponent(0.5)
//
//        self.addInnerShadowWithRadius(radius: 3.0, color: color, inDirection: FZInnerShadowDirection.All)
//    }
//
//    func addInnerShadowWithRadius(radius: CGFloat, andAlpha: CGFloat) {
//        let c = UIColor()
//        let color = c.withAlphaComponent(alpha)
//
//        self.addInnerShadowWithRadius(radius: radius, color: color, inDirection: FZInnerShadowDirection.All)
//    }
//
//    func addInnerShadowWithRadius(radius: CGFloat, andColor: UIColor) {
//        self.addInnerShadowWithRadius(radius: radius, color: andColor, inDirection: FZInnerShadowDirection.All)
//    }
//
//    func addInnerShadowWithRadius(radius: CGFloat, color: UIColor, inDirection: FZInnerShadowDirection) {
//        self.removeInnerShadow()
//
//        let shadowView = self.createShadowViewWithRadius(radius: radius, andColor: color, direction: inDirection)
//
//        self.addSubview(shadowView)
//        self.sendSubview(toBack: shadowView)
//    }
//
//    private func createShadowViewWithRadius(radius: CGFloat, andColor: UIColor, direction: FZInnerShadowDirection) -> UIView {
//        let shadowView = UIView(frame: CGRect(x: 0,y: 0,width: self.bounds.size.width,height: self.bounds.size.height))
//        shadowView.backgroundColor = UIColor.clear
//        shadowView.tag = 2639
//
//        let colorsArray: Array = [ andColor.cgColor, UIColor.clear.cgColor ]
//
//        if direction.contains(.Top) {
//            let xOffset: CGFloat = 0.0
//            let topWidth = self.bounds.size.width
//
//            let shadow = CAGradientLayer()
//            shadow.colors = colorsArray
//            shadow.startPoint = CGPoint(x: 0.5,y: 0.0)
//            shadow.endPoint = CGPoint(x: 0.5,y: 1.0)
//            shadow.frame = CGRect(x: xOffset,y: 0,width: topWidth,height: radius)
//            shadowView.layer.insertSublayer(shadow, at: 0)
//        }
//
//        if direction.contains(.Bottom) {
//            let xOffset: CGFloat = 0.0
//            let bottomWidth = self.bounds.size.width
//
//            let shadow = CAGradientLayer()
//            shadow.colors = colorsArray
//            shadow.startPoint = CGPoint(x: 0.5,y: 1.0)
//            shadow.endPoint = CGPoint(x: 0.5,y: 0.0)
//            shadow.frame = CGRect(x: xOffset,y: self.bounds.size.height - radius, width: bottomWidth,height: radius)
//            shadowView.layer.insertSublayer(shadow, at: 0)
//        }
//
//        if direction.contains(.Left) {
//            let yOffset: CGFloat = 0.0
//            let leftHeight = self.bounds.size.height
//
//            let shadow = CAGradientLayer()
//            shadow.colors = colorsArray
//            shadow.frame = CGRect(x: 0,y: yOffset,width: radius,height: leftHeight)
//            shadow.startPoint = CGPoint(x: 0.0,y: 0.5)
//            shadow.endPoint = CGPoint(x: 1.0,y: 0.5)
//            shadowView.layer.insertSublayer(shadow, at: 0)
//        }
//
//        if direction.contains(.Right) {
//            let yOffset: CGFloat = 0.0
//            let rightHeight = self.bounds.size.height
//
//            let shadow = CAGradientLayer()
//            shadow.colors = colorsArray
//            shadow.frame = CGRect(x: self.bounds.size.width - radius,y: yOffset, width: radius,height: rightHeight)
//            shadow.startPoint = CGPoint(x: 1.0,y: 0.5)
//            shadow.endPoint = CGPoint(x: 0.0,y: 0.5)
//            shadowView.layer.insertSublayer(shadow, at: 0)
//        }
//
//        return shadowView
//    }
    
    func dashedBorderLayerWithColor(color:CGColor) -> CAShapeLayer {
        
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0,y: 0,width: frameSize.width,height: frameSize.height)
        
        borderLayer.bounds=shapeRect
        borderLayer.position = CGPoint(x: frameSize.width/2,y: frameSize.height/2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color
        borderLayer.lineWidth=1
        borderLayer.lineJoin=kCALineJoinRound
        borderLayer.lineDashPattern = NSArray(array: [NSNumber(value: 8),NSNumber(value:4)]) as? [NSNumber]
        
        let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
        
        borderLayer.path = path.cgPath
        
        return borderLayer
    }
}
