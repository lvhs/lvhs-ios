source 'https://github.com/CocoaPods/Specs.git'

pod 'UITextFieldWithLimit'
pod 'AFNetworking'
pod 'MagicalRecord'
pod 'SVProgressHUD'
pod 'MBProgressHUD'
pod 'UIAlertView+Blocks'
pod 'UIActionSheet+Blocks'
pod 'SDWebImage'
#pod 'MBPhotoBrowser'
pod 'FontAwesomeKit'
pod 'mockingbird-toolbox'
pod 'HexColors'
pod 'Base64'
pod 'CrittercismSDK'
pod 'MTStatusBarOverlay'
pod 'CocoaLumberjack'
pod 'SSZipArchive'
pod 'Realm'
pod 'XCDYouTubeKit'

# UI/UX
pod "Repro" # https://repro.io/

# replacement for UITableViewController & UICollectionViewController
# pod "SlackTextViewController" https://github.com/slackhq/SlackTextViewController

# pod 'GLDTween', '~> 1.0' # https://github.com/theguildjp/GLDTween/

# https://github.com/azu/LupinusHTTP
# pod "LupinusHTTP"

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r(
    'Pods/Target Support Files/Pods/Pods-acknowledgements.plist',
    'LiveHouse/Settings.bundle/Acknowledgements.plist',
    :remove_destination => true
  )
end

# vim: ft=ruby :
