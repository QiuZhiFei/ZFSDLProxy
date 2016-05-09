Pod::Spec.new do |s|
  s.name         = 'ZFSDLProxy'
  s.version      = '0.0.1'
  s.summary      = 'A convenient connection between app and car base on SmartDeviceLink-iOS'
  s.platform     = :ios, '7.0'
  s.homepage = 'https://github.com/QiuZhiFei/ZFSDLProxy'
  s.author = { 'ZhiFei Qiu' => 'qiuzhifei521@gmail.com' }
  s.source = { :git => 'https://github.com/QiuZhiFei/ZFSDLProxy.git', :tag => s.version.to_s }
  s.frameworks    = "ExternalAccessory"
  s.source_files  = "Source/*.{h,m}"
  s.requires_arc = true
  
  s.dependency 'SmartDeviceLink-iOS',           	'~> 4.1.0'
  s.dependency 'JRSwizzle',               		    '~> 1.0'

end