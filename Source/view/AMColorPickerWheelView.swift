//
//  AMColorPickerWheelView.swift
//  AMColorPicker, https://github.com/adventam10/AMColorPicker
//
//  Created by am10 on 2018/01/04.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

public class AMColorPickerWheelView: XibLioadView, AMColorPicker {
    
    weak public var delegate: AMColorPickerDelegate?
    public var isSelectedColorShown: Bool = true {
        didSet {
            headerView?.isHidden = !isSelectedColorShown
        }
    }
    public var selectedColor: UIColor = .white {
        didSet {
            displayColor(selectedColor)
        }
    }
    
    @IBOutlet weak private var headerView: UIView!
    @IBOutlet weak private var opacityLabel: UILabel!
    @IBOutlet weak private var brightnessLabel: UILabel!
    @IBOutlet weak private var opacitySlider: UISlider!
    @IBOutlet weak private var colorView: UIView!
    @IBOutlet weak private var brightnessSlider: AMColorPickerSlider!
    @IBOutlet weak private var colorPickerImageView: UIImageView! {
        didSet {
            colorPickerImageView.isUserInteractionEnabled = true
            let pan = UIPanGestureRecognizer(target: self, action: #selector(self.gestureAction(gesture:)))
            colorPickerImageView.addGestureRecognizer(pan)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.gestureAction(gesture:)))
            colorPickerImageView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak private var cursorImageView: UIImageView!
    
    private var radius: CGFloat {
        return colorPickerImageView.frame.width/2
    }
    private var pickerCenter: CGPoint {
        return colorPickerImageView.center
    }
    
    override public func draw(_ rect: CGRect) {
        displayColor(selectedColor)
    }
    
    // MARK:- Gesture Action
    @objc func gestureAction(gesture: UIGestureRecognizer) {
        let point = gesture.location(in: colorPickerImageView.superview)
        let path = UIBezierPath(ovalIn: colorPickerImageView.frame)
        if path.contains(point) {
            didSelect(color: calculateColor(point: point))
        }
    }
    
    // MARK:- IBAction
    @IBAction private func changedSlider(_ slider: UISlider) {
        didSelect(color: calculateColor(point: cursorImageView.center))
    }
    
    // MARK:- SetColor
    private func setSliderColor(color: UIColor) {
        let hsba = color.hsba
        brightnessSlider.setGradient(startColor: .clear,
                                     endColor: .init(hue: hsba.hue, saturation: hsba.saturation,
                                                     brightness: 1.0, alpha: 1.0))
    }
    
    private func didSelect(color: UIColor) {
        selectedColor = color
        delegate?.colorPicker(self, didSelect: color)
    }
    
    private func displayColor(_ color: UIColor) {
        colorView.backgroundColor = color
        cursorImageView.center = calculatePoint(color: color)
        
        let hsba = color.hsba
        let alpha = hsba.alpha * 100
        let brightness = hsba.brightness * 100
        opacityLabel.text = alpha.colorFormatted
        brightnessLabel.text = brightness.colorFormatted
        opacitySlider.value = Float(alpha)
        brightnessSlider.value = Float(brightness)
        
        setSliderColor(color: color)
    }
    
    // MARK:- Calculate
    private func calculateColor(point: CGPoint) -> UIColor {
        // Since the upper side of the screen for obtaining the coordinate difference
        // is set as the Y coordinate +, the sign of Y coordinate is replaced
        let x = point.x - pickerCenter.x
        let y = -(point.y - pickerCenter.y)
        
        // Find the radian angle
        var radian = atan2f(Float(y), Float(x))
        if radian < 0 {
            radian += Float(Double.pi*2)
        }
        
        let distance = CGFloat(sqrtf(Float(pow(Double(x), 2) + pow(Double(y), 2))))
        let saturation = (distance > radius) ? 1.0 : distance / radius
        let brightness = CGFloat(brightnessSlider.value) / 100.0
        let alpha = CGFloat(opacitySlider.value) / 100.0
        let hue = CGFloat(radian / Float(Double.pi*2))
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    private func calculatePoint(color: UIColor) -> CGPoint {
        let hsba = selectedColor.hsba
        let angle = Float(hsba.hue) * Float(Double.pi*2)
        let smallRadius = hsba.saturation * radius
        let point = CGPoint(x: pickerCenter.x + smallRadius * CGFloat(cosf(angle)),
                            y: pickerCenter.y + smallRadius * CGFloat(sinf(angle))*(-1))
        return point
    }
}
