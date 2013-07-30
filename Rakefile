# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-settings-bundle'
require 'bundler' 
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Blood Pressure Reducer'
  app.frameworks += ['AVFoundation']
end

Motion::SettingsBundle.setup do |app|
  # Actual app prefs
  app.slider "Binaural Volume", key: "binauralVolume", default: 50, min: 1, max: 100
  app.slider "Ambient Volume", key: "ambientVolume", default: 50, min: 1, max: 100
  app.slider "Tone Volume", key: "toneVolume", default: 50, min: 1, max: 100

  # A text field. Allows configuration of a string.
  # app.text "Name", key: "username", default: "Paul Atreides"
  # app.text "E-mail", key: "email", keyboard: "EmailAddress", autocapitalization: "None"
  # app.text "Password", key: "password", secure: true

  # A read-only text field. Use for showing a small chunk of text, maybe a version number
  # app.title "Year of Birth", key: "yearOfBirth", default: "10,175 AG"

  # An on/off switch. Turn something on or off. Default is `false` (off).
  # app.toggle "Kwisatz Haderach?", key: "superpowersEnabled", default: true

  # A slider, configure volume or something linear
  # app.slider "Spice Level", key: "spiceLevel", default: 50, min: 1, max: 100

  # Child pane to display licenses in
  # app.child "Acknowledgements" do |ack|
  #   ack.child "AwesomeOSSLibrary" do |lic|
  #     lic.group "Copyright 2013 AwesomeOSSContributor"
  #     lic.group "More license text that is terribly formatted but fulfills legal requirements"
  #   end
  # end
end
