.xccolortheme goes into ~/Library/Application Support/Xcode/Color Themes

.xclangspec goes into /Developer/Library/Xcode/Specifications (make the dir)

.xcsynspec goes into /Developer/Library/Xcode/Specifications

Also copy the Builtin* file to the Specifications dir.

By default Xcode opens ObjC header files in ObjC++ mode which is irritating.

Until I get the syntax worked into the ObjC++ grammar (yeah right), then
if you don't want to be telling Xcode all the time not to use the default
(because you can't set it), you will want to use the ObjC++ override
grammar I have here, which is basically a near copy of the ObjC grammar.

Good luck.

