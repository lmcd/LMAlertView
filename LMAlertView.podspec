Pod::Spec.new do |s|
  s.name     = 'LMAlertView'
  s.version  = '1.0'
  s.license  = 'MIT'
  s.summary  = 'Open Source, customisable clone of UIAlertView for iOS 7'
  s.homepage = 'https://github.com/lmcd/LMAlertView'
  s.authors  = { 'Lee McDermott' => 'lmalertview@leemcdermott.co.uk' }
  s.source   = { :git => 'https://github.com/lmcd/LMAlertView.git' }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.dependency 'RBBAnimation'

  s.public_header_files = 'LMAlertView/*.h'
  s.source_files = 'LMAlertView/LMAlertView.h'
end