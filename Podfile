# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Memo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Pocket Note
  pod 'RealmSwift' 
  pod 'SwiftLint'
  pod 'SlideMenuControllerSwift'  
  pod 'PSOperations/Core', '~> 3.0' 
  pod 'ProcedureKit/All'
  pod 'DZNEmptyDataSet'
  
  def testing_pods
    pod 'Quick'
    pod 'Nimble'
  end

  target 'MemoTests' do
    inherit! :search_paths
    # Pods for testing
    testing_pods
  end

  target 'MemoUITests' do
    inherit! :search_paths
    # Pods for testing
    testing_pods
  end

end
