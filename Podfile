# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Pocket Note' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Pocket Note
  pod 'RealmSwift' 
  pod 'SwiftLint'
  pod 'Swinject', '~> 2.1.0'
  pod 'SlideMenuControllerSwift'  
  pod 'PSOperations'

  def testing_pods
    pod 'Quick'
    pod 'Nimble'
  end

  target 'Pocket NoteTests' do
    inherit! :search_paths
    # Pods for testing
    testing_pods
  end

  target 'Pocket NoteUITests' do
    inherit! :search_paths
    # Pods for testing
    testing_pods
  end

end
