![AMColorPicker](https://github.com/Tobaloidee/AMColorPicker/blob/master/logo/logotype-a.png)

![Pod Platform](https://img.shields.io/cocoapods/p/AMColorPicker.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/AMColorPicker.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/AMColorPicker.svg?style=flat)](http://cocoapods.org/pods/AMColorPicker)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`AMColorPicker`  can select color by three ways.

## Demo

![colorpicker](https://user-images.githubusercontent.com/34936885/34912854-08240a12-f92f-11e7-8f1a-f1589ca8f8ec.gif)

|  Wheel  |  Table  |  Slider  |
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
colorPickerViewController.selectedColor = .red
colorPickerViewController.delegate = self
present(colorPickerViewController, animated: true, completion: nil)
```

### Customization
`AMColorPicker` can be customized via the following properties.

```swift
public var selectedColor: UIColor = .white
public var isCloseButtonShown: Bool = true
public var isSelectedColorShown: Bool = true
```

#### Modal
|  Wheel  |  Table  |  Slider  |
| ---- | ---- | ---- |
|  ![modal_w](https://user-images.githubusercontent.com/34936885/66719031-9b681100-ee25-11e9-9c3b-e9b15b5519e6.png) |  ![modal_t](https://user-images.githubusercontent.com/34936885/66719024-9014e580-ee25-11e9-9973-1dac2b90251d.png)  |  ![modal_s](https://user-images.githubusercontent.com/34936885/66719021-825f6000-ee25-11e9-8ebb-dc85a0dc26a9.png)  |

#### Push
|  Wheel  |  Table  |  Slider  |
| ---- | ---- | ---- |
|  ![push_w](https://user-images.githubusercontent.com/34936885/66719044-b63a8580-ee25-11e9-97ef-dbe1aa543378.png)  |  ![push_t](https://user-images.githubusercontent.com/34936885/66719039-ab7ff080-ee25-11e9-9d0c-941c2c42a478.png)  |  ![push_s](https://user-images.githubusercontent.com/34936885/66719035-a327b580-ee25-11e9-80cc-53d01172e792.png)  |

#### Popover
Min height is 380.

|  Wheel  |  Table  |  Slider  |
| ---- | ---- | ---- |
|  ![pop_w](https://user-images.githubusercontent.com/34936885/66719052-cf433680-ee25-11e9-9ae8-6c376df192ba.png)  |  ![pop_t](https://user-images.githubusercontent.com/34936885/66719051-c81c2880-ee25-11e9-9230-6d90125fd096.png)  |  ![pop_s](https://user-images.githubusercontent.com/34936885/66719046-bfc3ed80-ee25-11e9-9861-d52fa66dbeb8.png)  |

#### Dark Mode
|  Wheel  |  Table  |  Slider  |
| ---- | ---- | ---- |
|  ![dark_w](https://user-images.githubusercontent.com/34936885/66719020-74a9da80-ee25-11e9-9403-056694fe1ab0.png)  |  ![dark_t](https://user-images.githubusercontent.com/34936885/66719018-6d82cc80-ee25-11e9-8404-3ed4581b326c.png)  |  ![dark_s](https://user-images.githubusercontent.com/34936885/66719011-5cd25680-ee25-11e9-824e-e3e0a2e272a0.png)  |

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
