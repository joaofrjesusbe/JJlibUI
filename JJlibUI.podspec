Pod::Spec.new do |s|
  s.name         = "JJlibUI"
  s.version      = "0.5.1"
  s.summary      = "JJlibUI - simplify UI"
  s.description  = <<-DESC
                   A library to help create simple and customize UI.
                   DESC
  s.homepage     = "https://github.com/joaofrjesusbe/JJlibUI"
  s.screenshots  = "https://raw.github.com/joaofrjesusbe/JJlibUI/master/Screenshot.png"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "João Jesus" => "joaofrjesusbe@gmail.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/joaofrjesusbe/JJlibUI.git", :tag => "0.1.3" }
  s.source_files  = 'JJlibUI/Source/**'
  s.requires_arc  = true
end
