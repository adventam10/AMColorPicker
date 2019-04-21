Pod::Spec.new do |s|
    s.name         = "AMColorPicker"
    s.version      = "2.0"
    s.summary      = "AMColorPicker can select color by three ways."
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.homepage     = "https://github.com/adventam10/AMColorPicker"
    s.author       = { "am10" => "adventam10@gmail.com" }
    s.source       = { :git => "https://github.com/adventam10/AMColorPicker.git", :tag => "#{s.version}" }
    s.platform     = :ios, "9.0"
    s.requires_arc = true
    s.source_files = 'AMColorPickerViewController/**/*.{swift}'
    s.resources    = 'AMColorPickerViewController/**/*.{xib,png}'
    s.swift_version = "5.0"
end
