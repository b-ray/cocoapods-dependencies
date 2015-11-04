# cocoapods-dependencies

Based on the default cocoapods-dependencies plugin, but with a slightly different usage.
Shows a project's CocoaPod dependency graph with both upward (pods with dependency to the specified library) and downward dependencies (dependencies of the current library).

## Installation

Currently, the plugin has to be installed as follows and replaces the default cocoapods-dependencies plugin.

```bash
$ [sudo] gem install specific_install
$ [sudo] gem specific_install -l https://github.com/b-ray/cocoapods-dependencies.git
```

## Usage

```bash
$ pod dependencies [REPO] [PODNAME]
```

e.g. printing the dependencies of the `Google`-library:

```bash
$ pod dependencies master Google
```

prints:

```bash
Dependencies
Upwards (pods with dependency to Google):
---
- - ARAnalytics -> Google
- - AppFriends -> Google
- - GoogleAnalyticsHelper -> Google
- - LiquidEventsInterceptor -> Google
- - Lock-Google -> Google
- - TAKGAUtil -> Google
Downwards (dependencies of Google):
---
- - Google -> AppInvites
  - Google -> GGLInstanceID
  - Google -> GoogleAnalytics
  - Google -> GoogleCloudMessaging
  - Google -> GoogleInterchangeUtilities
  - Google -> GoogleMobileAds
  - Google -> GoogleNetworkingUtilities
  - Google -> GoogleSignIn
  - Google -> GoogleSymbolUtilities
  - Google -> GoogleUtilities
```
