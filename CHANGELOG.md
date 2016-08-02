# Change log

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