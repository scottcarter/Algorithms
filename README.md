# Algorithms

iPad demo showing Core Plot, KxMenu integration along with interfaces to various C++ algorithms and routines.


# Overview 

This is intended to be a demo project that currently shows the following main concepts:

- Core Plot integration for graphing
- KxMenu integration (for drop down menus)
- Inclusion of C++ files in Xcode project
- Code Syntax highlighting in a Web view using highlight.js
- Sending e-mail with attachments
- Including source code in Bundle Resources
- Dynamically instantiating view controllers used in Popovers
- Using Macros (Project.h, Global.h)
  - Messaging
  - Errors & Exceptions
  - Flags for Instruments
- UML code documentation (using yEd) - see CodeOverview.graphml, CodeOverview.pdf

Some detailed concepts that are demonstrated include:

- Using didMoveToSuperview in a UIView for initialization after addSubview
- Fix for erratic scrolling in UITextView
- Core Plot
  - Subclassing CPTGraphHostingView to get notifications from drawRect for indication that host view bounds are completly set (awakeFromNib and didMoveToSuperview are too early for this).
  - Precise horizontal label positioning in Core Plot using initWithContentLayer: in place of initWithText: with CPTAxisLabel.
- Using the AppDelegate to initialize a shared data structure (between Master and Detail UISplitViewController controllers) and avoid race condition
- Using Introspection (respondsToSelector) before calling custom view methods.
- Runtime method call using performSelector: along with the #pragma directives to suppress warnings.
- Loading a UIView from a XIB resource.


## Bundle Resources

I wanted to include the ability to attach some code source (included in target dependency) in 
an e-mail message.  

In order to get runtime read access to a file, it must be included in the Resource Bundle.
For .mm or .cpp files, as soon as they are added to the Resource Bundle, they are automatically added
to Target Membership of our app.   What gets copied upon installation
is the corresponding object file, not the .mm or .cpp file itself.

In order to get runtime access to selected header and implementation files, we create links in
a Source subdirectory to our source file using the filename with .txt appended.  These links are then
added to the Resource Bundle.  The links are useful as we do not then need to keep 2 copies
of the same source file (one for compiling and one with a .txt extension for reading).

Upon installation, the links are resolved into text files which
can then be read by the app at runtime.


## UITextView scroll fix

I noted that programatically scrolling a UITextView in iOS 7 had the unwanted behavior of first scrolling
to the top of content before scrolling to the desired position.

There is a thread discussing this at:

[Scroll to bottom of UITextView erratic in iOS 7](http://stackoverflow.com/questions/19124037/scroll-to-bottom-of-uitextview-erratic-in-ios-7)

The fix looks like this:

```
    [self.textView setScrollEnabled:NO];
    [self.textView scrollRangeToVisible:NSMakeRange([self.textView.text length], 0)];
    [self.textView setScrollEnabled:YES];
```



# Installation

Navigate to the folder where you downloaded the project (Ex: algorithms-master) and execute 

**pod install**

Assumes that CocoaPods is installed on your system.  See References section.



# Launching

Be sure to open **Algorithms.xcworkspace** and not Algorithms.xcodeproj since the project relies on Pods.

Build and Run.



# References

[CocoaPods](http://cocoapods.org) - Dependency manager

[KxMenu](https://github.com/kolyvan/kxmenu) - Vertical popup menus 

[highlight.js](https://highlightjs.org) - Syntax highlighting for the Web

[yEd Graph Editor](http://www.yworks.com/en/products_yed_about.html) - Free editor to create diagrams



