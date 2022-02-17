# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def reactive
  pod 'RxSwift',             '~> 6.2.0'
  pod 'RxCocoa',             '~> 6.2.0'
  pod 'RxAlamofire',         '~> 6.1.1'
  pod 'RxRestClient',        '~> 3.0.0'
  pod 'RxOptional',          '~> 5.0.1'
  pod 'RxSwiftExt',          '~> 6.0.1'
  pod 'NSObject+Rx',
   :git => 'https://github.com/hovaks/NSObject-Rx.git',
   :commit => 'b3e81ea2f796f92c3bccc101d3b3f925759af96d'
end

def dependency_injection
  pod 'Swinject',                 '~> 2.7.1'
  pod 'SwinjectAutoregistration', '~> 2.7.0'
end

target 'iConverter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  reactive
  dependency_injection

  target 'iConverterTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'iConverterUITests' do
    # Pods for testing
  end

end
