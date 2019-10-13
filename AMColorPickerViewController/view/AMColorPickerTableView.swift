//
//  AMColorPickerTableView.swift
//  AMColorPicker, https://github.com/adventam10/AMColorPicker
//
//  Created by am10 on 2018/01/03.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

public class AMColorPickerTableView: UIView, AMColorPicker {

    weak public var delegate: AMColorPickerDelegate?
    public var selectedColor: UIColor = .white {
        didSet {
            colorView.backgroundColor = selectedColor
            let alpha = selectedColor.rgba.alpha * 100
            opacityLabel.text = alpha.colorFormatted
            opacitySlider.value = Float(alpha)
        }
    }
    
    @IBOutlet weak private var opacityLabel: UILabel!
    @IBOutlet weak private var opacitySlider: UISlider!
    @IBOutlet weak private var colorView: UIView!
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            let nib = UINib(nibName: "AMColorPickerTableViewCell", bundle: Bundle(for: AMColorPickerTableView.self))
            tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
            tableView.tableFooterView = UIView()
        }
    }
    
    private let cellIdentifier = "AMColorPickerTableViewCell"
    private let dataList: [AMCPCellInfo] = [
        .init(title: "Black", color: .black), .init(title: "Blue", color: .blue),
        .init(title: "Brown", color: .brown), .init(title: "Cyan", color: .cyan),
        .init(title: "Green", color: .green), .init(title: "Magenta", color: .magenta),
        .init(title: "Orange", color: .orange), .init(title: "Purple", color: .purple),
        .init(title: "Red", color: .red), .init(title: "Yellow", color: .yellow),
        .init(title: "White", color: .white)
    ]
    
    // MARK:- Initialize
    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    private func loadNib() {
        let bundle = Bundle(for: AMColorPickerTableView.self)
        let view = bundle.loadNibNamed("AMColorPickerTableView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    // MARK:- IBAction
    @IBAction private func changedOpacitySlider(_ slider: UISlider) {
        opacityLabel.text = slider.value.colorFormatted
        didSelect(color: colorView.backgroundColor!)
    }
    
    // MARK:- SetColor
    private func didSelect(color: UIColor) {
        let rgba = color.rgba
        let alpha = opacityLabel.text!.cgFloatValue / 100.0
        let selectColor = UIColor(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: alpha)
        colorView.backgroundColor = selectColor
        delegate?.colorPicker(self, didSelect: selectColor)
    }
    
    // MARK:- Reload
    public func reloadTable() {
        tableView.reloadData()
        tableView.setContentOffset(.zero, animated: false)
    }
}

extension AMColorPickerTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(color: dataList[indexPath.row].color)
    }
}

extension AMColorPickerTableView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AMColorPickerTableViewCell
        cell.info = dataList[indexPath.row]
        return cell
    }
}
