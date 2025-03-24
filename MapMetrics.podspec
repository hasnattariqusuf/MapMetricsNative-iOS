Pod::Spec.new do |spec|
  spec.name         = "MapMetrics"
  spec.version      = "0.0.2"
  spec.summary      = "MapMetrics SDK - A powerful mapping framework"
  spec.description  = "MapMetrics is a powerful tool that provides offline mapping capabilities with custom features."
  spec.homepage     = "https://github.com/hasnattariqusuf/MapMetricsNative-iOS"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Hasnat Tariq" => "hasnattariqusuf@gmail.com" }
  spec.platform     = :ios, "12.0"

  # Use the correct Git tag
  spec.source       = { :git => "https://github.com/hasnattariqusuf/MapMetricsNative-iOS.git", :tag => spec.version.to_s }

  # Include the XCFramework
  spec.vendored_frameworks = "MapMetrics.xcframework"

  # Ensure it is correctly embedded when installed
  spec.pod_target_xcconfig = {
    "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "arm64",
    "OTHER_LDFLAGS" => "-framework MapMetrics",
    "LD_RUNPATH_SEARCH_PATHS" => "@executable_path/Frameworks"
  }
  
  spec.user_target_xcconfig = {
    "LD_RUNPATH_SEARCH_PATHS" => "@executable_path/Frameworks"
  }

end
