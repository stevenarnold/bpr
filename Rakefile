# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'rubygems'
require 'motion/project/template/ios'
require 'bundler'
Bundler.setup
Bundler.require
require 'motion-settings-bundle'
require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Blood Pressure Reducer'
  app.version = '4.0'
  app.device_family = [:iphone, :ipad]
  app.identifier = 'com.arnold-software.BloodPressureReducer'
  app.frameworks += ['AVFoundation']
  app.icons = ["Icon.png", "Icon@2x.png"]
  app.pods do
    pod 'InAppSettingsKit'
  end
  app.info_plist['UIBackgroundModes'] = ['audio']
  app.release do
    app.provisioning_profile = "/Users/thoth/Library/MobileDevice/Provisioning Profiles/E3CB101B-C4FA-4D1B-94C5-DB3292695215.mobileprovision"
    app.codesign_certificate = "iPhone Distribution: Arnold Software Associates, Inc"
  end
  app.development do
    app.provisioning_profile = "/Users/thoth/Library/MobileDevice/Provisioning Profiles/4B484971-E5F8-46D0-BED4-16337A0CF83C.mobileprovision"
    app.codesign_certificate = "iPhone Developer: Steven Arnold (78N87GRK5G)"
  end
end

Motion::SettingsBundle.setup do |app|
  # Actual app prefs
  app.title "Binaural Volume", key: "binauralVolumeTitle", default: ""
  app.slider "Binaural Volume", key: "binauralVolume", default: 50, min: 1, max: 100
  app.multivalue "Ambient Program", key: "ambientProgram", default: "rain.mp3",
    values: ["rain.mp3", "ocean.m4a", "forest.m4a"], titles: ["Rain", "Ocean", "Forest"]
  app.title "Ambient Volume", key: "ambientVolumeTitle", default: ""
  app.slider "Ambient Volume", key: "ambientVolume", default: 50, min: 1, max: 100
  app.title "Tone Volume", key: "toneVolumeTitle", default: ""
  app.slider "Tone Volume", key: "toneVolume", default: 50, min: 1, max: 100
  app.title "Ending Sound Volume", key: "endingSoundVolumeTitle", default: ""
  app.slider "Ending Sound Volume", key: "endingSoundVolume", default: 50, min: 1, max: 100
end
