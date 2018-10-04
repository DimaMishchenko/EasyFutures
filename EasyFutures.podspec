Pod::Spec.new do |s|
  s.name             = 'EasyFutures'
  s.version          = '1.2.0'
  s.summary          = 'EasyFutures'
 
  s.description      = <<-DESC
Easy Futures & Promises.
                       DESC
 
  s.homepage         = 'https://github.com/DimaMishchenko/EasyFutures'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dima Mishchenko' => 'narmdv5@gmail.com' }
  s.source           = { :git => 'https://github.com/DimaMishchenko/EasyFutures.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.2'
  s.source_files = 'EasyFutures/*'
  s.exclude_files = "EasyFutures/*.plist"
 
end