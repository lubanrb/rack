# Change log

## Version 0.3.0 (Mar 28, 2017)
  * Set up Puma/Thin web server configurations appropriately for dockerization

Bug fixes:
  * Compared excluded templates with their basename instead of full path

## Version 0.2.25 (Feb 23, 2017)

Minor enhancements:
  * Bump up gem dependency of Luban to version 0.12.8
    * To make use of an enhancement of cleaning up Bundler environment before executing any worker tasks
    * So that code can be cleaned up in a more concise way

## Version 0.2.24 (Jan 03, 2017)

Minor enhancements:
  * Cleaned up Bundler environment for control actions and web server publishing

## Version 0.2.23 (Nov 27, 2016)

Minor enhancements:
  * Specified control_file_dir to properly handle linked files
  * Bump up gem dependency of Luban to version 0.10.8

Bug fixes:
  * Fixed superclass mismatch exception when loading gem from filesystem directly
  * Properly included common paths for Publisher


## Versoin 0.2.21 (Nov 24, 2016)

Minor enhancements:
  * Made use of linked_files convention
    * Relocated puma.rb.erb to templates/puma/config
    * Relocated thin.yml.erb to templates/thin/config
    * As a result, bump up gem dependency of Luban to version 0.10.4

## Version 0.2.20 (Nov 17, 2016)

Bug fixes:
  * Fixed Nginx proxy configuration for Rails precompiled assets serving

## Version 0.2.19 (Nov 16, 2016)

Bug fixes:
  * Updated plugin 'luban' to be backward compatible with Ruby 1.8
  * Monkey patched on class Puma::Plugin to ensure backward compatibility with Ruby 1.8

## Version 0.2.18 (Nov 14, 2016)

Minor enhancements:
  * Added publish callback for web server
  * Added Puma plugin for Luban integration to
    * Solved process tag unchanged during phase restart
    * Loaded app from releast path directly instead of current_app_path 

## Version 0.2.16 (Nov 09, 2016)

Bug fixes:
  * Used current app path instead of release path to walk around Puma restart_dir issue
  * Changed default threads for Puma to "1:1" to ensure single thread
    * Developers need to ensure their app is thread-safe before turning up this setting

## Version 0.2.15 (Oct 30, 2016)

Bug fixes:
  * Correctly set the default value for #web_server

## Version 0.2.14 (Oct 23, 2016)

Minor enhancements:
  * Cleaned up the design and implementation of Rack app parameters in a deployment project
    * As a result, bump up gem dependency on Luban to version 0.9.10

## Version 0.2.13 (Oct 19, 2016)

Minor enhancements:
  * Utilized new parameters, #logrotate_max_age, #logrotate_count, from Luban to unify logrotate setup
  * Bump up gem dependency of Luban to version 0.9.8

## Version 0.2.12 (Oct 12, 2016)

Minor enhancements:
  * Updated logrotate configuration
  * Deprecated logrotate related paths because logrotate is managed in Uber
    * As a result, bump up gem dependency of Luban to version 0.9.0

Bug fixes:
  * Checked excluded templates from super in Configurator

## Version 0.2.11 (Sept 28, 2016)

Minor enhancements:
  * Applied subcommand grouping for better clarity
    * As a result, bump up gem dependency of Luban to version 0.8.8

## Version 0.2.10 (Sept 27, 2016)

Bug fixes:
  * Renamed #process_monitorable? to #monitorable? due to the change from Luban
    * As a result, bump up the gem dependency of Luban to version 0.8.7

## Version 0.2.9 (Sept 21, 2016)

Bug fixes:
  * Changed default server address to 127.0.0.1 for both Thin and Puma
  * Changed Puma default port next to the web server port
  * Passed the right arguments to monitor_command/unmonitor_command
  * Checked if process is monitorable before enable/disable process monitoring

## Version 0.2.8 (Sept 20, 2016)

Bug fixes:
  * Fixed a bug in the init chain for Rack::Controller

## Version 0.2.7 (Sept 19, 2016)

Minor enhancements:
  * Refactored the way of composing shell commands
    * As a result, bumped up the gem dependency on Luban to version 0.8.0

## Version 0.2.6 (Sept 04, 2016)

Bug fixes:
  * Overloaded #shell_command_prefix method in all worker classes
  * Minor bug fixes

## Version 0.2.5 (Sept 01, 2016)

Minor enhancements:
  * Added bundle exec to the shell command prefix if gemfile is found
  * Bump up gem dependency of Luban to version 0.7.11
  * Minor code cleanup

## Version 0.2.4 (Aug 30, 2016)

Minor enhancements: 
  * Changed linked_dirs/linked_files setup to Publisher
    * As a result, bump up the gem dependency of Luban to version 0.7.5

## Version 0.2.3 (Aug 22, 2016)

Minor enhancements:
  * Linked control file from app profile to the app config directory
    * As a result, updated gem dependency on Luban to version 0.7.1

## Version 0.2.2 (Aug 18, 2016)

Minor enhancments:
  * Changed default web server from thin to puma
  * Used #compose_command from Luban to support shell setup commands
    * As a result, updated gem dependency on Luban to version 0.7.0

## Version 0.2.1 (Aug 05, 2016)

Bug fixes:
  * Changed mechanism for adding default templates path in order to handle templates paths inheritance
    * As a result, updated gem dependency on Luban to version 0.6.8

## Version 0.2.0 (Aug 02, 2016)

New features:
  * Supported Puma as web server option
  * Enhanced Thin cluster support

Minor enhancements:
  * Used convenient method #application_action to define action method for phased restart
    * Updated gem dependency on luban to version 0.6.7
  * Renamed nginx template file for Thin/Puma for better file naming conventions
  * Added #public_files_path to specify static contents served by Rack application
  * Added convenient methods to manage web servers:
    * #web_servers_available to get web servers available to use
    * #current_web_server to get web server being currently used
    * #web_servers_unused to get web server NOT being currently used
  * Overloaded template filter method #exclude_template? to properly avoid rendering profile for web servers that are not currently used
  * Added convenient methods, #tcp_socket? and #unix_socket?, to properly determine whether tcp or unix socket is being specified
  * Rename #set_default_web_server_options to #set_web_server_options for better clarity
  * Minor code cleanup

Bug fixes:
  * Refactored #default_templates_path to fix an inheritance issue
  * Corrected the process matching regular expressions

## Version 0.1.2 (Jul 14, 2016)

New features:
  * Supported generation of Nginx proxy configuration

* Bug fixes:
  * Fixed issues to correctly set default web server options for Configurator and Controller
  * Corrected issues when composing socket file path for cluster
  * Changed the starting port for cluster to avoid conflicting to the actual port the web app uses

## Version 0.1.1 (Jul 11, 2016)

New features:
  * Refactored web server for Rack to support cluster

## Version 0.1.0 (Jul 08, 2016)

New features:
  * Initialized Luban deployment application for Rack
    * Added support for web server Thin
