

Pod::Spec.new do |s|

  s.name         = "SAPublicModule"
  s.version      = "0.0.1"
  s.summary      = "CollectionViewGridLayout封装,加减Button封装,网易滚动视图,textView提示文字"
  s.platform     = :ios, '8.0'

  s.homepage     = "https://github.com/SAndL9/SAPublicModule"

  s.license      = "MIT"

  s.author             = { "李磊" => "lilei@iscs.com.cn" }

  s.requires_arc = true
  s.source       = { :git => "https://github.com/SAndL9/SAPublicModule.git", :tag => s.version.to_s }

  s.subspec 'SANumberButton' do |ss|
  ss.source_files = 'SAPublicModule/SAPublicModule/SANumberButton/*.{h,m}'
  end

  s.subspec 'SACollectionViewGridLayout' do |ss|
  ss.source_files = 'SAPublicModule/SAPublicModule/SACollectionViewGridLayout/*.{h,m}'
  end

  s.subspec 'SALabelLineBetweenSpace' do |ss|
  ss.source_files = 'SAPublicModule/SAPublicModule/SALabelLineBetweenSpace/*.{h,m}'
  end

  s.subspec 'SATopScrollView' do |ss|
  ss.source_files = 'SAPublicModule/SAPublicModule/SATopScrollView/*.{h,m}'
  end

  s.dependency 'Masonry', '~> 1.0.2'










end
