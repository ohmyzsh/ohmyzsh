## forklift

Plugin for ForkLift, an FTP application for OS X.

### Requirements

* [ForkLift](http://www.binarynights.com/forklift/)

### Usage

<code>fl [*file_or_folder*]</code>

* If `fl` is called without arguments then the current folder is opened in ForkLift. This is equivalent to `fl .`.

* If `fl` is called with a directory as the argument, then that directory is opened in ForkLift. If called with a non-directory file as the argument, then the file's parent directory is opened.
