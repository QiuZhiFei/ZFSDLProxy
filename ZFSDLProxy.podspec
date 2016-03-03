Pod::Spec.new do |s|
  s.name         = "ZFSDLProxy"
  s.version      = "1.0.0"
  s.summary      = "ZFSDLProxy"
  s.requires_arc = true
  s.platform     = :ios, '7.0'
  
  s.frameworks    = "ExternalAccessory"
  s.source_files  = "Source/*.{h,m}"
  
  s.dependency 'SmartDeviceLink-iOS',                '~> 4.0.1'
  s.dependency 'JRSwizzle',               		'~> 1.0'

end