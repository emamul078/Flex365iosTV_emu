//
//  Spinner.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 12/9/22.
//

import Foundation
import UIKit

class Spinner: UIView {

    private var circleLayer = CAShapeLayer()
    private var strokeLineAnimation = CAAnimationGroup()
    private var rotationAnimation = CAAnimation()
    private var strokeColorAnimation = CAAnimation()
    private var colorArray = [UIColor]()
    private var isAnimating = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup(color:UIColor.systemRed, width: 3.0)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup(color:UIColor.systemRed, width: 3.0)
    }

    func initialSetup(color: UIColor, width: Double){
        circleLayer = CAShapeLayer()
        layer.addSublayer(circleLayer)

        backgroundColor = UIColor.clear
        circleLayer.fillColor = nil
        circleLayer.lineWidth = width
        circleLayer.lineCap = .round

        colorArray.append(color)

        updateAnimations()
    }

    func finishingSetup() {
        circleLayer.removeAllAnimations()
        circleLayer.removeFromSuperlayer()
    }

    override func layoutSubviews() {
        let center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        let radius = Double(min(bounds.size.width, bounds.size.height)) / 2.0 - circleLayer.lineWidth / 2.0
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * .pi

        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        circleLayer.path = path.cgPath
        circleLayer.frame = bounds
    }

    func updateAnimations(){
        // Stroke Head
        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.beginTime = 1.5 / 3.0
        headAnimation.fromValue = NSNumber(value: 0)
        headAnimation.toValue = NSNumber(value: 1)
        headAnimation.duration = 2 * 1.5 / 3.0
        headAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        // Stroke Tail
        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.fromValue = NSNumber(value: 0)
        tailAnimation.toValue = NSNumber(value: 1)
        tailAnimation.duration = 2 * 1.5 / 3.0
        tailAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        // Stroke Line Group
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.5
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [headAnimation, tailAnimation]
        strokeLineAnimation = animationGroup

        // Rotation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = NSNumber(value: 0)
        rotationAnimation.toValue = NSNumber(value: 2 * Double.pi)
        rotationAnimation.duration = 1.5
        rotationAnimation.repeatCount = .infinity
        self.rotationAnimation = rotationAnimation

        let strokeColorAnimation = CAKeyframeAnimation(keyPath: "strokeColor")
        strokeColorAnimation.values = prepareColorValues()
        strokeColorAnimation.keyTimes = prepareKeyTimes()
        strokeColorAnimation.calculationMode = .discrete
        strokeColorAnimation.duration = Double(colorArray.count) * 1.5
        strokeColorAnimation.repeatCount = .infinity
        self.strokeColorAnimation = strokeColorAnimation
    }

    func prepareColorValues() -> [AnyHashable]? {
        var cgColorArray: [AnyHashable] = []
        for color in colorArray {
            cgColorArray.append(color.cgColor)
        }
        return cgColorArray
    }

    func prepareKeyTimes() -> [NSNumber]? {
        var keyTimesArray: [NSNumber] = []
        for i in 0..<(colorArray.count + 1) {
            keyTimesArray.append(NSNumber(value: Double(i) * 1.0 / Double(colorArray.count)))
        }
        return keyTimesArray
    }

    func startApiLoader() {
        isAnimating = true
        initialSetup(color:UIColor.systemRed, width: 2.0)
        circleLayer.add(strokeLineAnimation, forKey: "strokeLineAnimation")
        circleLayer.add(rotationAnimation, forKey: "rotationAnimation")
        circleLayer.add(strokeColorAnimation, forKey: "strokeColorAnimation")
    }

    func stopApiLoader() {
        isAnimating = false
        circleLayer.removeAnimation(forKey: "strokeLineAnimation")
        circleLayer.removeAnimation(forKey: "rotationAnimation")
        circleLayer.removeAnimation(forKey: "strokeColorAnimation")
        finishingSetup()
    }
    
    func isAnimation() -> Bool{
        return isAnimating
    }
}
