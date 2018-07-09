Pod::Spec.new do |s|
  s.name             = 'EasyFuture'
  s.version          = '1.0.0'
  s.summary          = 'EasyFuture'
 
  s.description      = <<-DESC
Easy futures & promises.
                       DESC
 
  s.homepage         = 'https://github.com/DimaMishchenko/EasyFuture'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dima Mishchenko' => 'narmdv5@gmail.com' }
  s.source           = { :git => 'https://github.com/DimaMishchenko/EasyFuture.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '9.0'
  s.source_files = 'EasyFuture/EasyFuture/*'
 
end