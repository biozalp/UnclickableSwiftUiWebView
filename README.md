# Unclickable SwiftUI WebView

## Overview

This Swift view file provides a secure WebView implementation for iOS applications that prevents user interactions with hyperlinks and external navigation. It is designed to display web content in a controlled, read-only manner, ensuring users cannot accidentally navigate away from the intended page.

## Features

- Disables all hyperlinks within the WebView
- Prevents link clicks and navigation
- Blocks new window openings
- Disables link previews
- Supports loading web content with configurable preferences

## Installation

### Manual Installation

1. Just copy and paste the codefrom the view file into your project.

## Usage

### Basic Implementation

```swift
struct ContentView: View {
    var body: some View {
        UnclickableSwiftUiWebView()
    }
}

### Customizing the URL

Modify the `unclickableURL` in `UnclickableSwiftUiWebView` struct:

```swift
private let unclickableURL = URL(string: "https://your-website.com/privacy")!
```

## Configuration Details

The WebView includes the following security configurations:

- Disabled JavaScript window opening
- Prevented link interactions
- Removed download attributes
- Blocked link previews
- Limited navigation gestures

## Customization

You can further customize the WebView by modifying:
- `WKWebpagePreferences`
- `WKWebViewConfiguration`
- JavaScript injection script

## Potential Use Cases

- Privacy policy displays
- Terms of service pages
- Read-only web content presentation
- Secure informational web views

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Berk Ilgar Özalp - berk@biozalp.com

Project Link: [https://github.com/biozalp/UnclickableSwiftUiWebView](https://github.com/biozalp/UnclickableSwiftUiWebView)