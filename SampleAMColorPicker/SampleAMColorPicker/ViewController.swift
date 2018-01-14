//
//  ViewController.swift
//  SampleAMColorPicker
//
//  Created by am10 on 2018/01/08.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedButton(_ sender: Any) {
        
        let vc = AMColorPickerViewController()
        vc.selectedColor = UIColor.red
        present(vc, animated: true, completion: nil)
    }
    
}

