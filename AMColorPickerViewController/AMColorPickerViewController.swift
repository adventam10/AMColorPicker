//
//  AMColorPickerViewController.swift
//  AMColorPicker, https://github.com/adventam10/AMColorPicker
//
//  Created by am10 on 2018/01/03.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

public protocol AMColorPickerViewControllerDelegate: class {
    func colorPickerViewController(_ colorPickerViewController: AMColorPickerViewController, didSelect color: UIColor)
}

public class AMColorPickerViewController: UIViewController {

    enum SegmentIndex:Int {
        case picker = 0
        case table = 1
        case slider = 2
    }
    
    weak public var delegate:AMColorPickerViewControllerDelegate?
    public var selectedColor:UIColor = UIColor.white
    
    @IBOutlet weak private var cpWheelView: AMColorPickerWheelView!
    @IBOutlet weak private var cpTableView: AMColorPickerTableView!
    @IBOutlet weak private var cpSliderView: AMColorPickerRGBSliderView!
    @IBOutlet weak private var segment: UISegmentedControl!
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        let bundle = Bundle(for: AMColorPickerViewController.self)
        super.init(nibName: "AMColorPickerViewController", bundle: bundle)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cpTableView.delegate = self
        cpSliderView.delegate = self
        cpWheelView.delegate = self
        
        cpSliderView.selectedColor = selectedColor
        cpTableView.selectedColor = selectedColor
        cpWheelView.selectedColor = selectedColor
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: IBAction
    @IBAction private func changedSegment(_ sender: UISegmentedControl) {
        cpSliderView.closeKeyboard()
        guard let index = SegmentIndex.init(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        switch index {
        case .picker:
            cpWheelView.isHidden = false
            cpTableView.isHidden = true
            cpSliderView.isHidden = true
        case .slider:
            cpWheelView.isHidden = true
            cpTableView.isHidden = true
            cpSliderView.isHidden = false
        case .table:
            cpTableView.reloadTable()
            cpWheelView.isHidden = true
            cpTableView.isHidden = false
            cpSliderView.isHidden = true
        }
    }
    
    @IBAction private func tappedCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension AMColorPickerViewController: AMColorPickerTableViewDelegate {
    public func colorPickerTableView(_ colorPickerTableView: AMColorPickerTableView, didSelect color: UIColor) {
        cpSliderView.selectedColor = color
        cpWheelView.selectedColor = color
        delegate?.colorPickerViewController(self, didSelect: color)
    }
}

extension AMColorPickerViewController: AMColorPickerRGBSliderViewDelegate {
    public func colorPickerRGBSliderView(_ colorPickerRGBSliderView: AMColorPickerRGBSliderView, didSelect color: UIColor) {
        cpTableView.selectedColor = color
        cpWheelView.selectedColor = color
        delegate?.colorPickerViewController(self, didSelect: color)
    }
}

extension AMColorPickerViewController: AMColorPickerWheelViewDelegate {
    public func colorPickerWheelView(_ colorPickerWheelView: AMColorPickerWheelView, didSelect color: UIColor) {
        cpTableView.selectedColor = color
        cpSliderView.selectedColor = color
        delegate?.colorPickerViewController(self, didSelect: color)
    }
}
