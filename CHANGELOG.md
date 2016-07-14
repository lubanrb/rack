# Change log

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