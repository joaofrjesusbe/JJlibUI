Pod::Spec.new do |s|
  s.name          = "JJlibUI"
  s.version       = "0.1.3"
  s.summary       = "A library to help create simple and customize UI"
  s.homepage      = "https://github.com/joaofrjesusbe/JJlibUI.git"
  s.screenshots   = "https://raw.github.com/joaofrjesusbe/JJlibUI/master/Screenshot.png"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "João Jesus" => "joaofrjesusbe@gmail.com" }
  s.source        = { :git => "https://github.com/joaofrjesusbe/JJlibUI.git", :tag => "#{s.version}" }
  s.platform      = :ios, '5.0'
  s.source_files  = 'JJlibUI/Source/**'
  s.requires_arc  = true
end

