Pod::Spec.new do |spec|
  spec.name         = "MapMetrics"
  spec.version      = "0.0.1"
  spec.summary      = "MapMetrics SDK - A powerful mapping framework"
  spec.description  = "MapMetrics is a powerful tool that provides offline mapping capabilities with custom features."
  spec.homepage     = "https://github.com/hasnattariqusuf/MapMetricsNative-iOS"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Hasnat Tariq" => "hasnattariqusuf@gmail.com" }
  spec.platform     = :ios, "12.0"
  spec.source       = { :git => "https://github.com/hasnattariqusuf/MapMetricsNative-iOS.git", :tag => "1" }
  spec.vendored_frameworks = "MapMetrics.xcframework"
end
