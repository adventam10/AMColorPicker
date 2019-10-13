//
//  ViewController.swift
//  SampleAMColorPicker
//
//  Created by am10 on 2018/01/08.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak private var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    }
    
    @IBAction func tappedModalButton(_ sender: Any) {
        let colorPickerViewController = AMColorPickerViewController()
        colorPickerViewController.selectedColor = colorView.backgroundColor!
        colorPickerViewController.delegate = self
        present(colorPickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func tappedPushButton(_ sender: Any) {
        let colorPickerViewController = AMColorPickerViewController()
        colorPickerViewController.isCloseButtonShown = false
        colorPickerViewController.selectedColor = colorView.backgroundColor!
        colorPickerViewController.delegate = self
        navigationController?.pushViewController(colorPickerViewController, animated: true)
    }
    
    @IBAction func tappedPopoverButton(_ sender: Any) {
        let colorPickerViewController = AMColorPickerViewController()
        colorPickerViewController.isCloseButtonShown = false
        colorPickerViewController.isSelectedColorShown = false
        colorPickerViewController.selectedColor = colorView.backgroundColor!
        colorPickerViewController.delegate = self
        colorPickerViewController.modalPresentationStyle = .popover
        colorPickerViewController.preferredContentSize = CGSize(width: 300, height: 380)
        
        let presentationController = colorPickerViewController.popoverPresentationController
        presentationController?.delegate = self
        presentationController?.permittedArrowDirections = .any
        let button = sender as! UIButton
        presentationController?.sourceView = button
        presentationController?.sourceRect = button.bounds
        present(colorPickerViewController, animated: true, completion: nil)
    }
}

extension ViewController: AMColorPickerDelegate {
    func colorPicker(_ colorPicker: AMColorPicker, didSelect color: UIColor) {
        colorView.backgroundColor = color
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
