Pod::Spec.new do |s|
s.name             = "iOS-BaseTools"
s.version          = "1.0.0"
s.summary          = "iOS based development kit"
s.description      = <<-DESC
                    iOS based development kit,create by ArthurShuai
                    DESC
s.homepage         = "https://github.com/Arthur-Coding/iOS-BaseTools"
s.license          = 'MIT'
s.author           = { "ArthurShuai" => "zhixingui_liushuai@163.com" }
s.source           = { :git => "https://github.com/Arthur-Coding/iOS-BaseTools.git", :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/NAME'

s.platform     = :ios, '8.0'
# s.ios.deployment_target = '5.0'
# s.osx.deployment_target = '10.7'
s.requires_arc = true

s.source_files = 'iOS基础开发包/*'
# s.resources = 'Assets'

# s.exclude_files = 'Classes/*’
# s.public_header_files = 'Classes/**/*.h'
s.frameworks = 'Foundation','UIKit','CoreGraphics'
s.dependency "AFNetworking"
s.dependency "SDWebImage"
s.dependency "Masonry"

end
