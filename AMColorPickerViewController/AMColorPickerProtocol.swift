//
//  AMColorPickerProtocol.swift
//  SampleAMColorPicker
//
//  Created by am10 on 2019/04/21.
//  Copyright © 2019 am10. All rights reserved.
//

import UIKit

public protocol AMColorPicker: NSObject {
}

public protocol AMColorPickerDelegate: class {
    func colorPicker(_ colorPicker: AMColorPicker, didSelect color: UIColor)
}
