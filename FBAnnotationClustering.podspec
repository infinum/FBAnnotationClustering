Pod::Spec.new do |s|
  s.name             = 'FBAnnotationClustering'
  s.version          = '0.2.2'
  s.summary          = 'Clustering library for iOS maps'
  s.homepage         = 'https://github.com/infinum/FBAnnotationClustering'
  s.screenshots      = 'https://raw.githubusercontent.com/infinum/FBAnnotationClustering/master/Images/example.png'
  s.license          = 'MIT'
  s.author           = { 'Filip Beć' => 'filip.bec@gmail.com' }
  s.source           = { :git => 'https://github.com/infinum/FBAnnotationClustering.git', :tag => '0.2.2' }
  s.social_media_url = 'https://twitter.com/FilipBec'
  s.requires_arc     = true

  s.ios.deployment_target  = '6.0'
  s.tvos.deployment_target = '9.2'

  s.source_files            = 'FBAnnotationClustering'
  s.public_header_files     = 'FBAnnotationClustering/*.h'

  s.frameworks = 'CoreLocation', 'MapKit'
end
