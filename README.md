# JBits

This Swift Package is a collection of decorators and custom classes written in Swift 5 that I keep reusing in my projects. Maybe you'll find this framework useful too?

I will not keep this readme file up-to-date. However, I'll try to present the more useful components of the package - so you get an idea of what you'll get.

## Custom

- **Log**; a very easy weay to log something in the debug area, or in the console of live apps. For the former, all logs are completely removed for release builds. The cool thing about using this is the consistency of the logs, as it has a log type identifier with clear user guidelines.

## Foundation

- **Codable Character**; for a game I've been working on.
- **Optional Collection Index**; trying to reach an out-of-bounds index in a collection simply returns nil.
- **Currency Amount String Interpolation**; an easy way to get the `Int` or `Float` formatted as a currency amount.
- **Camel Case Formatting of Strings**; collapses a string into a camel cased word, you can chose upper and lower camel case.
- **Reading Time**; how long will it take to read the provided text? Backed up by science.

## UIKit

- **CGPath from a Character**; turn a character into a CGPath the easy way.
- **Optically correct saturation adjustment**; unlike available saturation tweaking, this method simply removes the color - as expected.
- **Contrasting Color**; a very convenient way to create a new color that harmonizes with another color.
- **Throb and shake animations for UIView**; nice visual effects to use in certain situations - like when an element is tapped or refreshed.
- **A activity spinner on visuals effects backdrop**; all ready to be dropped into your view stack.
