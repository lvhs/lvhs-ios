source 'https://github.com/CocoaPods/Specs.git'

pod 'UITextFieldWithLimit'
pod 'AFNetworking'
pod 'MagicalRecord'
pod 'SVProgressHUD'
pod 'MBProgressHUD'
pod 'UIAlertView+Blocks'
pod 'UIActionSheet+Blocks'
pod 'UIAlertController+Blocks'
pod 'SDWebImage'
# pod 'MBPhotoBrowser'
pod 'FontAwesomeKit'
pod 'mockingbird-toolbox'
pod 'HexColors'
pod 'Base64'
pod 'CrittercismSDK'
pod 'MTStatusBarOverlay'
pod 'CocoaLumberjack'
pod 'SSZipArchive'
pod 'Realm'

#pod 'YTVimeoExtractor'
pod 'YTVimeoExtractor', git: 'https://github.com/lilfaf/YTVimeoExtractor.git', branch: 'hotfix/vimeoapi'

pod 'MKStoreKit'
pod 'TTTAttributedLabel'

# UI/UX
pod 'Repro' # https://repro.io/

# versioning
pod 'SRGVersionUpdater', git: 'https://github.com/munky69rock/SRGVersionUpdater.git'

# replacement for UITableViewController & UICollectionViewController
# pod "SlackTextViewController" https://github.com/slackhq/SlackTextViewController

# pod 'GLDTween', '~> 1.0' # https://github.com/theguildjp/GLDTween/

# https://github.com/azu/LupinusHTTP
# pod "LupinusHTTP"

# https://github.com/thegreatloser/DebugView
# pod 'DebugView', '~> 0.0'

# https://github.com/ryanmaxwell/RMUniversalAlert
# pod 'RMUniversalAlert'

# http://qiita.com/IamAtmosphere/items/e0b4f7b3a70f02a15139
# pod 'MSAlertController'

# swift

# AutoLayout
# https://github.com/kzms/Crew

post_install do |installer|
  require 'fileutils'
  FileUtils.cp_r(
    'Pods/Target Support Files/Pods/Pods-acknowledgements.plist',
    'LiveHouse/Settings.bundle/Acknowledgements.plist',
    remove_destination: true
  )

  installer.pods_project.build_configurations.each do |config|
    config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
  end
end

# vim: ft=ruby :
