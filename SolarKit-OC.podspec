Pod::Spec.new do |s|
  s.name         = "SolarKit-OC"
  s.version      = "0.0.1"
  s.summary      = "SolarKit-OC"
  s.homepage     = "https://github.com/ThreeGayHub/SolarKit-OC"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "devxoul" => "wyhazq@foxmail.com" }
  s.source       = { :git => "https://github.com/ThreeGayHub/SolarKit-OC.git",
                     :tag => "#{s.version}" }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'SolarKit-OC/**/*'
  s.frameworks   = 'Foundation', 'UIKit'
end
