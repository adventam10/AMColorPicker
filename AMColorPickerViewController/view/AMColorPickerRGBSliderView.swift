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
    
    override public var bounds: CGRect {
        didSet {
            rgbSliderStackView.spacing = bounds.height < 488 ? 16 : 32
            if isKeyboardShown && bounds.height < 200 {
                // when keyboard is shown (popover style)
                rgbSliderStackView.isHidden = true
                opacityStackView.isHidden = true
            } else {
                rgbSliderStackView.isHidden = false
                opacityStackView.isHidden = false
            }
        }
    }
    
    @IBOutlet weak private var headerView: UIView!
    @IBOutlet weak private var redSlider: AMColorPickerSlider!
    @IBOutlet weak private var greenSlider: AMColorPickerSlider!
    @IBOutlet weak private var blueSlider: AMColorPickerSlider!
    @IBOutlet weak private var opacitySlider: UISlider!
    @IBOutlet weak private var rgbSliderStackView: UIStackView!
    @IBOutlet weak private var redLabel: UILabel!
    @IBOutlet weak private var greenLabel: UILabel!
    @IBOutlet weak private var blueLabel: UILabel!
    @IBOutlet weak private var opacityLabel: UILabel!
    @IBOutlet weak private var colorView: UIView!
    @IBOutlet weak private var opacityStackView: UIStackView!
    @IBOutlet weak private var hexTextField: UITextField! {
        didSet {
            hexTextField.addTarget(self, action: #selector(self.didChange(textField:)), for: .editingChanged)
            hexTextField.delegate = self
            
            let notification = NotificationCenter.default
            notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                     name: UIResponder.keyboardWillShowNotification, object: nil)
            notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                     name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    private var isKeyboardShown: Bool = false
    private var previousText = ""
    
    private let colorCodeLength = 6
    private let colorCodeCharacterSet = CharacterSet(charactersIn: "0123456789abcdef")
    
    // MARK:- UITextField Action
    @objc func didChange(textField: UITextField) {
        // Retrieve the inputted characters
        guard let newText = textField.text else {
            return
        }
        if !colorCodeCharacterSet.isSuperset(of: CharacterSet(charactersIn: newText.lowercased())) {
            textField.text = previousText
            return
        }
        if newText.count != colorCodeLength {
            return
        }
        didSelect(color: UIColor(hex: newText, alpha: CGFloat(opacitySlider.value) / 100.0))
    }
    
    // MARK:- Keyboard Notification
    @objc func keyboardWillShow(_ notification: Notification?) {
        isKeyboardShown = true
    }

    @objc func keyboardWillHide(_ notification: Notification?) {
        isKeyboardShown = false
    }
    
    // MARK:- IBAction
    @IBAction private func changedSlider(_ slider: UISlider) {
        let red = CGFloat(redSlider.value) / 255.0
        let green = CGFloat(greenSlider.value) / 255.0
        let blue = CGFloat(blueSlider.value) / 255.0
        let alpha = CGFloat(opacitySlider.value) / 100.0
        didSelect(color: UIColor(red: red, green: green, blue: blue, alpha: alpha))
    }
    
    // MARK:- SetColor
    private func didSelect(color: UIColor) {
        selectedColor = color
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
    
    private func displayColor(_ color: UIColor) {
        colorView.backgroundColor = color
        let rgba = color.rgba
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
        
        hexTextField.text = color.colorCode
        setSliderColor(color: color)
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
        if prospectiveText.count > colorCodeLength {
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
