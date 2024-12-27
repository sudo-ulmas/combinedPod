def use_flutter_modules!
  plugins_dir = File.join('Flutter', 'plugins')

  
  # Link FlutterPluginRegistrant
  flutter_plugin_registrant_path = File.expand_path('FlutterPluginRegistrant',plugins_dir)
  pod 'FlutterPluginRegistrant', :path => flutter_plugin_registrant_path, :inhibit_warnings => true
  
  # Load and link Flutter plugins
  plugins_file = File.expand_path('.flutter-plugins-dependencies', plugins_dir)
  plugin_pods = flutter_parse_plugins_file(plugins_file)
  
  plugin_pods['plugins']['ios'].each do |plugin_hash|
    plugin_name = plugin_hash['name']
    has_native_build = plugin_hash.fetch('native_build', true)
    if plugin_name && has_native_build
      plugin_path = File.join(plugins_dir, plugin_name, 'ios')
      pod plugin_name, :path => plugin_path, :inhibit_warnings => true
    end
  end
end


def flutter_post_install(installer, skip: false)
  return if skip

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |_build_configuration|
      flutter_additional_ios_build_settings(target)
    end
  end
end

def flutter_parse_plugins_file(file)
  file_path = File.expand_path(file)
  return [] unless File.exist? file_path

  dependencies_file = File.read(file)
  JSON.parse(dependencies_file)
end

def flutter_additional_ios_build_settings(target)
  return unless target.platform_name == :ios

  # [target.deployment_target] is a [String] formatted as "8.0".
  inherit_deployment_target = target.deployment_target[/\d+/].to_i < 12

  # ARC code targeting iOS 8 does not build on Xcode 14.3.
  force_to_arc_supported_min = target.deployment_target[/\d+/].to_i < 9

  target.build_configurations.each do |build_configuration|
    # Build both x86_64 and arm64 simulator archs for all dependencies. If a single plugin does not support arm64 simulators,
    # the app and all frameworks will fall back to x86_64. Unfortunately that case is not detectable in this script.
    # Therefore all pods must have a x86_64 slice available, or linking a x86_64 app will fail.
    build_configuration.build_settings['ONLY_ACTIVE_ARCH'] = 'NO' if build_configuration.type == :debug

    # ARC code targeting iOS 8 does not build on Xcode 14.3. Force to at least iOS 9.
    build_configuration.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0' if force_to_arc_supported_min


    # Bitcode is deprecated, Flutter.framework bitcode blob will have been stripped.
    build_configuration.build_settings['ENABLE_BITCODE'] = 'NO'

    build_configuration.build_settings['OTHER_LDFLAGS'] = '$(inherited) -framework Flutter'

    build_configuration.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
    # Suppress warning when pod supports a version lower than the minimum supported by Xcode (Xcode 12 - iOS 9).
    # This warning is harmless but confusing--it's not a bad thing for dependencies to support a lower version.
    # When deleted, the deployment version will inherit from the higher version derived from the 'Runner' target.
    # If the pod only supports a higher version, do not delete to correctly produce an error.
    build_configuration.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET' if inherit_deployment_target

    # Override legacy Xcode 11 style VALID_ARCHS[sdk=iphonesimulator*]=x86_64 and prefer Xcode 12 EXCLUDED_ARCHS.
    build_configuration.build_settings['VALID_ARCHS[sdk=iphonesimulator*]'] = '$(ARCHS_STANDARD)'
    build_configuration.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = '$(inherited) i386'
    build_configuration.build_settings['EXCLUDED_ARCHS[sdk=iphoneos*]'] = '$(inherited) armv7'
  end
end

