//
//  AMColorPickerWheelView.swift
//  AMColorPicker, https://github.com/adventam10/AMColorPicker
//
//  Created by am10 on 2018/01/04.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

public class AMColorPickerWheelView: UIView, AMColorPicker {
    
    weak public var delegate:AMColorPickerDelegate?
    public var selectedColor:UIColor = UIColor.white {
        didSet {
            colorView.backgroundColor = selectedColor
            let point = calculatePoint(color: selectedColor)
            cursorImageView.center = point
            
            var hue:CGFloat = 0
            var saturation:CGFloat = 0
            var brightness:CGFloat = 0
            var alpha:CGFloat = 0
            selectedColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            alpha = alpha * 100
            brightness = brightness * 100
            
            opacityLabel.text = NSString(format: "%.0f", alpha) as String
            brightnessLabel.text = NSString(format: "%.0f", brightness) as String
            opacitySlider.value = Float(alpha)
            brightnessSlider.value = Float(brightness)
            
            setSliderColor(color: selectedColor)
        }
    }
    
    @IBOutlet weak private var opacityLabel: UILabel!
    @IBOutlet weak private var brightnessLabel: UILabel!
    @IBOutlet weak private var opacitySlider: UISlider!
    @IBOutlet weak private var colorView: UIView!
    @IBOutlet weak private var brightnessSlider: AMColorPickerSlider!
    
    @IBOutlet weak private var colorPickerImageView: UIImageView!
    @IBOutlet weak private var cursorImageView: UIImageView!
    
    //MARK:Initialize
    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    private func loadNib() {
        let bundle = Bundle(for: AMColorPickerWheelView.self)
        let view = bundle.loadNibNamed("AMColorPickerWheelView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        colorPickerImageView.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(gesture:)))
        colorPickerImageView.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(gesture:)))
        colorPickerImageView.addGestureRecognizer(tap)
    }
    
    override public func draw(_ rect: CGRect) {
        let point = calculatePoint(color: selectedColor)
        cursorImageView.center = point
    }
    
    //MARK:Gesture Action
    @objc func panAction(gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: colorPickerImageView.superview)
        let path = UIBezierPath(ovalIn: colorPickerImageView.frame)
        if path.contains(point) {
            cursorImageView.center = point
            didSelect(color: calculateColor(point: point))
        }
    }
    
    @objc func tapAction(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: colorPickerImageView.superview)
        let path = UIBezierPath(ovalIn: colorPickerImageView.frame)
        if path.contains(point) {
            cursorImageView.center = point
            didSelect(color: calculateColor(point: point))
        }
    }
    
    //MARK:IBAction
    @IBAction private func changedBrightnessSlider(_ slider: UISlider) {
        brightnessLabel.text = NSString(format: "%.0f", slider.value) as String
        didSelect(color: calculateColor(point: cursorImageView.center))
    }
    
    @IBAction private func changedOpacitySlider(_ slider: UISlider) {
        opacityLabel.text = NSString(format: "%.0f", slider.value) as String
        didSelect(color: calculateColor(point: cursorImageView.center))
    }
    
    //MARK:SetColor
    private func setSliderColor(color: UIColor) {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        
        color.getHue(&hue, saturation: &saturation, brightness: nil, alpha: nil)
        
        brightnessSlider.setGradient(startColor: UIColor.clear,
                                     endColor: UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0))
    }
    
    private func didSelect(color: UIColor) {
        setSliderColor(color: color)
        colorView.backgroundColor = color
        delegate?.colorPicker(self, didSelect: color)
    }
    
    //MARK:Calculate
    private func calculateColor(point: CGPoint) -> UIColor {
        let center = colorPickerImageView.center
        let radius = colorPickerImageView.frame.width/2

        // Since the upper side of the screen for obtaining the coordinate difference
        // is set as the Y coordinate +, the sign of Y coordinate is replaced
        let x = point.x - center.x
        let y = -(point.y - center.y)
        
        // Find the radian angle
        var radian = atan2f(Float(y), Float(x))
        if radian < 0 {
            radian += Float(Double.pi*2)
        }
        
        let distance = CGFloat(sqrtf(Float(pow(Double(x), 2) + pow(Double(y), 2))))
        let saturation = (distance > radius) ? 1.0 : distance/radius
        let brightness = CGFloat(brightnessSlider.value)/100.0
        let alpha = CGFloat(opacitySlider.value)/100.0;
        let hue = CGFloat(radian/Float(Double.pi*2))
        return UIColor(hue: hue,
                       saturation: saturation,
                       brightness: brightness,
                       alpha: alpha)
    }
    
    private func calculatePoint(color: UIColor) -> CGPoint {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        var brightness:CGFloat = 0
        var alpha:CGFloat = 0
        
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let center = colorPickerImageView.center
        let radius = colorPickerImageView.frame.width/2
        let angle = Float(hue) * Float(Double.pi*2)
        
        let smallRadius = saturation * radius
        let point = CGPoint(x: center.x + smallRadius * CGFloat(cosf(angle)),
                            y: center.y + smallRadius * CGFloat(sinf(angle))*(-1))
        
        return point
    }
}
