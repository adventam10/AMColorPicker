//
//  AMColorPickerRGBSliderView.swift
//  AMColorPicker, https://github.com/adventam10/AMColorPicker
//
//  Created by am10 on 2018/01/03.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

public class AMColorPickerRGBSliderView: XibLioadView, AMColorPicker {

    weak public var delegate: AMColorPickerDelegate?
    public var selectedColor: UIColor = .white {
        didSet {
            colorView.backgroundColor = selectedColor
            let rgba = selectedColor.rgba
            let red = rgba.red * 255
            let green = rgba.green * 255
            let blue = rgba.blue * 255
            let alpha = rgba.alpha * 100
            redLabel.text = red.colorFormatted
            greenLabel.text = green.colorFormatted
            blueLabel.text = blue.colorFormatted
            opacityLabel.text = alpha.colorFormatted
            
            redSlider.value = Float(red)
            greenSlider.value = Float(green)
            blueSlider.value = Float(blue)
            opacitySlider.value = Float(alpha)
            
            hexTextField.text = selectedColor.colorCode
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
    @IBOutlet weak private var hexTextField: UITextField! {
        didSet {
            hexTextField.addTarget(self, action: #selector(self.didChange(textField:)), for: .editingChanged)
            hexTextField.delegate = self
        }
    }
    
    private var previousText = ""
    
    // MARK:- UITextField Action
    @objc func didChange(textField: UITextField) {
        // Retrieve the inputted characters
        guard let newText = textField.text else {
            return
        }
        
        let characterSet = CharacterSet(charactersIn: "0123456789abcdef")
        if !characterSet.isSuperset(of: CharacterSet(charactersIn: newText.lowercased())) {
            textField.text = previousText
            return
        }
        
        if newText.count != 6 {
            return
        }
        
        let alpha = opacityLabel.text!.cgFloatValue / 100.0
        let color = UIColor(hex: newText, alpha: alpha)
        let rgba = color.rgba
        let red = rgba.red * 255
        let green = rgba.green * 255
        let blue = rgba.blue * 255
        redLabel.text = red.colorFormatted
        greenLabel.text = green.colorFormatted
        blueLabel.text = blue.colorFormatted
        
        redSlider.value = Float(red)
        greenSlider.value = Float(green)
        blueSlider.value = Float(blue)
        
        didSelect(color: color)
    }
    
    // MARK:- IBAction
    @IBAction private func changedRedSlider(_ slider: UISlider) {
        redLabel.text = slider.value.colorFormatted
        changedSlider()
    }
    
    @IBAction private func changedGreenSlider(_ slider: UISlider) {
        greenLabel.text = slider.value.colorFormatted
        changedSlider()
    }
    
    @IBAction private func changedBlueSlider(_ slider: UISlider) {
        blueLabel.text = slider.value.colorFormatted
        changedSlider()
    }
    
    @IBAction private func changedOpacitySlider(_ slider: UISlider) {
        opacityLabel.text = slider.value.colorFormatted
        changedSlider()
    }
    
    private func changedSlider() {
        let color = getColor()
        hexTextField.text = color.colorCode
        didSelect(color: color)
    }
    
    // MARK:- Calculate
    private func getColor() -> UIColor {
        let red = redLabel.text!.cgFloatValue / 255.0
        let green = greenLabel.text!.cgFloatValue / 255.0
        let blue = blueLabel.text!.cgFloatValue / 255.0
        let alpha = opacityLabel.text!.cgFloatValue / 100.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
        
    // MARK:- SetColor
    private func didSelect(color: UIColor) {
        colorView.backgroundColor = color
        setSliderColor(color: color)
        delegate?.colorPicker(self, didSelect: color)
    }
    
    private func setSliderColor(color: UIColor) {
        let rgba = color.rgba
        redSlider.setGradient(startColor: .init(red: 0.0, green: rgba.green, blue: rgba.blue, alpha: 1.0),
                              endColor: .init(red: 1.0, green: rgba.green, blue: rgba.blue, alpha: 1.0))
        blueSlider.setGradient(startColor: .init(red: rgba.red, green: rgba.green, blue: 0.0, alpha: 1.0),
                               endColor: .init(red: rgba.red, green: rgba.green, blue: 1.0, alpha: 1.0))
        greenSlider.setGradient(startColor: .init(red: rgba.red, green: 0.0, blue: rgba.blue, alpha: 1.0),
                                endColor: .init(red: rgba.red, green: 1.0, blue: rgba.blue, alpha: 1.0))
    }
    
    // MARK:- Close
    func closeKeyboard() {
        hexTextField.resignFirstResponder()
    }
}

extension AMColorPickerRGBSliderView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
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
