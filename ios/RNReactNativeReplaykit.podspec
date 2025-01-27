
Pod::Spec.new do |s|
  s.name         = "RNReactNativeReplaykit"
  s.version      = "1.1.0"
  s.summary      = "RNReactNativeReplaykit"
  s.description  = <<-DESC
                  RNReactNativeReplaykit
                   DESC
  s.homepage     = "https://github.com/code-matt/react-native-replaykit/"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author       = { "author" => "author@domain.cn" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/SharekApp/react-native-replaykit.git", :tag => "master" }
  s.source_files  = "RNReactNativeReplaykit/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  
