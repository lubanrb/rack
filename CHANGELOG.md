# Change log

## Version 0.2.6 (Sept 04, 2016)

Bug fixes:
  * Overloaded #shell_command_prefix method in all worker classes
  * 

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
