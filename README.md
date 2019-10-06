![AMColorPicker](https://github.com/Tobaloidee/AMColorPicker/blob/master/logo/logotype-a.png)

![Pod Platform](https://img.shields.io/cocoapods/p/AMColorPicker.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/AMColorPicker.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/AMColorPicker.svg?style=flat)](http://cocoapods.org/pods/AMColorPicker)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`AMColorPicker`  can select color by three ways.

## Demo

![colorpicker](https://user-images.githubusercontent.com/34936885/34912854-08240a12-f92f-11e7-8f1a-f1589ca8f8ec.gif)

|  wheel  |  table  |  slider  |
| ---- | ---- | ---- |
|  ![wheel](https://user-images.githubusercontent.com/34936885/35519518-d76bd3ca-0557-11e8-87f6-8f3c380b1583.png)  |  ![table](https://user-images.githubusercontent.com/34936885/35519545-eb43810e-0557-11e8-83a6-420cb32fe54a.png)  |  ![slider](https://user-images.githubusercontent.com/34936885/35519569-f804158e-0557-11e8-95ea-05318a72db47.png)  |

## Usage

Adopt the AMColorPickerDelegate protocol in the class declaration.

```swift
class ViewController: UIViewController, AMColorPickerDelegate
``` 

Conform to the protocol in the class implementation.

```swift
func colorPicker(_ colorPicker: AMColorPicker, didSelect color: UIColor) {    
    // use selected color here
}
```

Create and present the AMColorPicker as you see fit.

```swift
let colorPickerViewController = AMColorPickerViewController()
colorPickerViewController.selectedColor = UIColor.red
colorPickerViewController.delegate = self
present(colorPickerViewController, animated: true, completion: nil)
```

## Installation

### CocoaPods

Add this to your Podfile.

```ogdl
pod 'AMColorPicker'
```

### Carthage

Add this to your Cartfile.

```ogdl
github "adventam10/AMColorPicker"
```

## License

MIT
