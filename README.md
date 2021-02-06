# JBits

This Swift Package is a collection of decorators and custom classes written in Swift 5 that I keep reusing in my projects. Maybe you'll find this package useful too?

I will not keep this readme file up-to-date. However, I'll try to present the more useful components of the package - so you get an idea of what you're getting.

## Custom

- **Log**; a very easy way to log something in the Xcode debug area, or in the console of live apps (these logs can be retreived). For the former, all logs are completely removed for release builds. The cool thing about using this is the consistency of the logs, as it has a log type identifier with clear user guidelines.

## Foundation

- **Codable Character**; for a game I've been working on.
- **Optional Collection Index**; trying to reach an out-of-bounds index in a collection simply returns nil.
- **Currency Amount String Interpolation**; an easy way to get the `Int` or `Float` formatted as a currency amount.
- **Camel Case Formatting of Strings**; collapses a string into a camel cased word, both upper and lower camel case is available.
- **Reading Time**; how long will it take to read the provided text? This will tell you. Supported by science™.

## UIKit

- **CGPath from a Character**; turn a character into a CGPath the easy way.
- **Optically correct saturation adjustment**; unlike available saturation tweaking, my method actually works! It simply removes the color of any supported color - just as would expected (ref. examples below)
- **Contrasting Color**; a very convenient way to create a new color that harmonizes with another.
- **Throb and shake animations for UIView**; nice visual effects to use in certain situations - like when an element is tapped or refreshed.
- **An activity spinner on a visual-effects backdrop**; rounded corners, fully constrainted, all ready to be dropped into your view stack.


# Result of using withSaturation(_:)

The top half shows the result of using ``UIColor.withSaturation(_:)`` against 40 different colours, while the bottom half shows the same ``UIColor`` created with the same hue and brightness, but saturation set to zero.  

![Optically Desaturated Colours](/Media/comparison.png)

Below you see what happens to a color when saturation range from -1 to 1 using ``UIColor.withSaturation(_:)``.  

![Optically Desaturated Colours](/Media/fullrange.png)
