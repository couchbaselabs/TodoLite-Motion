## ToDo Lite for RubyMotion

This is a demo app showing how to use the [Couchbase Lite][CBL] framework to
embed a nonrelational ("NoSQL") document-oriented database in an iOS app and
sync it with [Couchbase Server][CBS] in "the cloud".

The app is a simple to-do list manager. Users can create multiple lists, each
with its own items that can be checked off when done. List are synced with all
the devices using the same Facebook login, and can sync with
[TodoLite-iOS](TODO_IOS), and [PhoneGap/Cordova][TODO_PHONEGAP].

This is a very crude first port of the TodoLite-iOS application to make it run
on run on [RubyMotion][RUBYMOTION].

## Building & Running The Demo App

Down to business: You should be familiar with how to build and run an iOS app.
And you'll need a copy of Xcode version 5 or later, as well as RubyMotion and
[CocoaPods][COCOAPODS].

If you have questions or get stuck or just want to say hi, please visit the
[Mobile Couchbase group][LIST] on Google Groups, or open an Issue.

1. Clone or download this repository.
2. Install the gem dependecies via ```bundle install```
3. Install all the dependencies via ```bundle exec rake pod:install```
4. Optionally configure the sync_gateway url in config/sync_gateway.rb
5. Run it by running ```rake```

That's it! Now that you're set up, you can just use the Run command again after
making changes to the demo code.

If you run your own sync_gateway, there is a rake task included for running with
the config supplied in ```support_files``` by running ```rake
services:sync_gateway```

## Caveats

Do to a bug in RubyMotion it is currently not possible to use ruby lambdas as
blocks for the query functions, so they need to be setup via Objective-C code
nativly. This has been worked around by including a simple Blocks xcode project
which includes the functions to setup the MapBlocks.

Currently this project is a pretty straight port of the TodoLite-iOS project,
and does not feel really ruby like, so look forward to new things to come in
regards to that!

## License

Released under the Apache license, 2.0.

Copyright 2011-2014, Couchbase, Inc.

[CBL]: https://github.com/couchbaselabs/Couchbase-Lite-iOS/
[CBS]: http://www.couchbase.com/couchbase-server/overview
[TODO_PHONEGAP]: https://github.com/couchbaselabs/TodoLite-PhoneGap
[TODO_IOS]: https://github.com/couchbaselabs/ToDoLite-iOS
[LIST]: https://groups.google.com/group/mobile-couchbase
[COCOAPODS]: http://cocoapods.org/
[RUBYMOTION]: http://www.rubymotion.com/
