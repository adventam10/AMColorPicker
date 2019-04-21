//
//  AMColorPickerRGBSliderView.swift
//  AMColorPicker, https://github.com/adventam10/AMColorPicker
//
//  Created by am10 on 2018/01/03.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

public class AMColorPickerRGBSliderView: UIView, AMColorPicker {

    weak public var delegate:AMColorPickerDelegate?
    public var selectedColor:UIColor = UIColor.white {
        didSet {
            colorView.backgroundColor = selectedColor
            var red:CGFloat = 0
            var green:CGFloat = 0
            var blue:CGFloat = 0
            var alpha:CGFloat = 0
            selectedColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            red = red * 255
            green = green * 255
            blue = blue * 255
            alpha = alpha * 100
            redLabel.text = NSString(format: "%.0f", red) as String
            greenLabel.text = NSString(format: "%.0f", green) as String
            blueLabel.text = NSString(format: "%.0f", blue) as String
            opacityLabel.text = NSString(format: "%.0f", alpha) as String
            
            redSlider.value = Float(red)
            greenSlider.value = Float(green)
            blueSlider.value = Float(blue)
            opacitySlider.value = Float(alpha)
            
            hexTextField.text = getHexString(color: selectedColor)
            
            setSliderColor(color: selectedColor)
        }
    }
    
    @IBOutlet weak private var redSlider: AMColorPickerSlider!
    @IBOutlet weak private var greenSlider: AMColorPickerSlider!
    @IBOutlet weak private var blueSlider: AMColorPickerSlider!
    @IBOutlet weak private var opacitySlider: UISlider!
    
    @IBOutlet weak private var redLabel: UILabel!
    @IBOutlet weak private var greenLabel: UILabel!
    @IBOutlet weak private var blueLabel: UILabel!
    @IBOutlet weak private var opacityLabel: UILabel!
    
    @IBOutlet weak private var colorView: UIView!
    @IBOutlet weak private var hexTextField: UITextField!
    
    private var previousText = ""
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    private func loadNib() {
        let bundle = Bundle(for: AMColorPickerRGBSliderView.self)
        let view = bundle.loadNibNamed("AMColorPickerRGBSliderView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        hexTextField.addTarget(self, action: #selector(self.didChange(textField:)), for: .editingChanged)
        hexTextField.delegate = self
    }
    
    //MARK:UITextField Action
    @objc func didChange(textField: UITextField) {
        // Retrieve the inputted characters
        guard let newText = textField.text else {
            return
        }
        
        let characterSet = CharacterSet(charactersIn: "0123456789abcdef")
        let stringCharacterSet = CharacterSet(charactersIn: newText.lowercased())
        
        if !characterSet.isSuperset(of: stringCharacterSet) {
            textField.text = previousText
            return
        }
        
        if newText.count != 6 {
            return
        }
        
        let alpha = NSString(string: opacityLabel.text!).floatValue/100.0
        let color = getHexColor(hexStr: newText, alpha: CGFloat(alpha))
       
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        red = red * 255
        green = green * 255
        blue = blue * 255
        redLabel.text = NSString(format: "%.0f", red) as String
        greenLabel.text = NSString(format: "%.0f", green) as String
        blueLabel.text = NSString(format: "%.0f", blue) as String
        
        redSlider.value = Float(red)
        greenSlider.value = Float(green)
        blueSlider.value = Float(blue)
        
        didSelect(color: color)
    }
    
    //MARK:IBAction
    @IBAction private func changedRedSlider(_ slider: UISlider) {
        redLabel.text = NSString(format: "%.0f", slider.value) as String
        let color = getColor()
        hexTextField.text = getHexString(color: color)
        didSelect(color: color)
    }
    
    @IBAction private func changedGreenSlider(_ slider: UISlider) {
        greenLabel.text = NSString(format: "%.0f", slider.value) as String
        let color = getColor()
        hexTextField.text = getHexString(color: color)
        didSelect(color: color)
    }
    
    @IBAction private func changedBlueSlider(_ slider: UISlider) {
        blueLabel.text = NSString(format: "%.0f", slider.value) as String
        let color = getColor()
        hexTextField.text = getHexString(color: color)
        didSelect(color: color)
    }
    
    @IBAction private func changedOpacitySlider(_ slider: UISlider) {
        opacityLabel.text = NSString(format: "%.0f", slider.value) as String
        let color = getColor()
        hexTextField.text = getHexString(color: color)
        didSelect(color: color)
    }
    
    //MARK:Calculate
    private func getColor() -> UIColor {
        let red = NSString(string: redLabel.text!).floatValue/255.0
        let green = NSString(string: greenLabel.text!).floatValue/255.0
        let blue = NSString(string: blueLabel.text!).floatValue/255.0
        let alpha = NSString(string: opacityLabel.text!).floatValue/100.0
        return UIColor(red: CGFloat(red),
                       green: CGFloat(green),
                       blue: CGFloat(blue),
                       alpha: CGFloat(alpha))
    }
    
    private func getHexString(color: UIColor) -> String {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb:Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return NSString(format: "%06x", rgb) as String
    }
    
    private func getHexColor(hexStr: String, alpha: CGFloat) -> UIColor {
        let hexString = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexString)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.white
        }
    }
    
    //MARK:SetColor
    private func didSelect(color: UIColor) {
        colorView.backgroundColor = color
        setSliderColor(color: color)
        delegate?.colorPicker(self, didSelect: color)
    }
    
    private func setSliderColor(color: UIColor) {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        redSlider.setGradient(startColor: UIColor(red: 0.0, green: green, blue: blue, alpha: 1.0),
                              endColor: UIColor(red: 1.0, green: green, blue: blue, alpha: 1.0))
        blueSlider.setGradient(startColor: UIColor(red: red, green: green, blue: 0.0, alpha: 1.0),
                              endColor: UIColor(red: red, green: green, blue: 1.0, alpha: 1.0))
        greenSlider.setGradient(startColor: UIColor(red: red, green: 0.0, blue: blue, alpha: 1.0),
                              endColor: UIColor(red: red, green: 1.0, blue: blue, alpha: 1.0))
    }
    
    //MARK:Close
    func closeKeyboard() {
        hexTextField.resignFirstResponder()
    }
}

extension AMColorPickerRGBSliderView: UITextFieldDelegate {
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        // Get the inputted text
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Determine the number of characters
        let maxInputLength = 6
        if prospectiveText.count > maxInputLength {
            return false
        }
        
        previousText = currentText
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
