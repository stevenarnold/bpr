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
  app.frameworks += ['AVFoundation']
  app.icons = ["Icon.png", "Icon-72.png", "Icon@2x.png"]
  app.pods do
    pod 'InAppSettingsKit'
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
end
