# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bubble-wrap'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'ToDoLite-Motion'
  app.frameworks += ['Accounts', 'Social']
  app.identifier = 'com.couchbase.ToDoLite-Motion'

  # Add config directory files
  app.files << Dir.glob('./config/*.rb')

  # Make sure the CouchbaseLite Headers are found
  # this makes CocoaPods kind of redundant but currently is the only way this works
  #
  # http://equip9.org/2014/03/06/adding-couchbase-in-a-rubymotion-app.html
  # https://groups.google.com/forum/#!topic/rubymotion/wVqdLWQ5uao
  #
  app.vendor_project('vendor/Pods/couchbase-lite-ios/couchbase-lite-ios-community-1.0.0/CouchbaseLite.framework',
                     :static,
                     products: ['CouchbaseLite'],
                     headers_dir: 'Headers')

  # since lambdas are not copyable like objective c blocks are, we need to actually create objective c once
  # and embed them in the project to provide them as map and reduce to our couchbase lite queries
  app.vendor_project('vendor/Blocks',
                     :xcode,
                     target: 'Blocks')

  app.pods do
    pod 'couchbase-lite-ios', '~> 1.0.0'
  end
end

# manage services needed to run the application
namespace :service do
  desc "Start sync_gateway with config ./support_files/sync-gateway-config.json"
  task :sync_gateway do
    fail "sync_gateway not found in PATH, check http://bit.ly/mac_sync_gw" unless command?("sync_gateway")
    system "sync_gateway ./support_files/sync-gateway-config.json"
  end
end

# check if a command exists on the current system
def command? cmd
  system "which #{cmd} > /dev/null 2>&1"
end


