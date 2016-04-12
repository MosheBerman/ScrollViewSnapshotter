# ScrollViewSnapshotter
A demo project showing how to correctly snapshot the contents UIScrollView and its subclasses.

About:
---
Historically, the suggested approach to snapshotting a scrollview was to resize the scroll view's  `frame` to match its `contentSize`. This became inconvenient with the introduction of autolayout on iOS.

This example scrolls through the contents of a scrollview subclass (in this case a collection view) and generates a PDF. 

The magic comes from translating the core graphics current transformation matrix along with the `contentOffset`. Check out the ScrollViewSnapshotter class for implementation details and a ton of notes. Those notes are also available on [my blog](http://blog.mosheberman.com/generating-a-pdf-from-a-uiscrollview/).

License:
---
MIT
