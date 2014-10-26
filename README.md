Xcode Enhanced Highlighting
===========================

Minior update for Xcode6 (better color scheme support)

xclangspec files and color schemes for Xcode3 and Xcode5 that allow you to target the method names in definitions and declarations for special highlighting. For Xcode5 also supports special colors for blocks (class methods, instance methods, and closure blocks can have different colors). Some work is needed as it is not compatible with context highlighting (i.e. project identifiers).  

I come from an Emacs background and am used to having function names in a high contrast color, which is easy to set up with Emacs highlighting packages. Xcode out of the box won't let you do this, unless you make some difficult modifications to the language parsing grammars. This is still a work in progress for Xcode5, especially for the header files as the ObjC++ langspec is required for all headers and I haven't modified that yet (lots of work).

Example images are included as well as a few color schemes. 

There is flexiblity to set individual colors for:

- class method names
- class method return type
- class method parameter types
- class method parameters

- instance method names
- instance method return type
- instance method parameter types
- instance method parameters

- separate colors for class and instance method definition blocks
- closure blocks ( i.e. ^{} type blocks) can be set to their own color as well

There is a problem with Xcode5 in that setting colors by grammar vs. setting colors by context (i.e. what clang/llvm hands back after parsing) seems to be incompatible so far. So using these will currently disable things like being able to special-highlight project class names. I have left notes in the grammars where the area is to focus on if someone can improve this.


== Special notes ==

1. *** Not tested vs. Xcode4 ***

2. You need to install these to:

---

sudo cp *.xclangspec *.xcsynspec \
/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/

---

3. You may have problems with other, older language specs installed
throughout your system. I nuked everything else I found in my system.
find / -name ObjectiveC.xclangspec -print is your friend. Xcode even has two
copies under the .app. I nuked the other one, because at the end of the
day YOU NEVER KNOW WHAT THE HELL XCODE IS GOING TO DO. Words to live by.
I don't think Apple even knows. In particular you may need to delete these:


---

sudo rm /Applications/Xcode.app/Contents/OtherFrameworks/XcodeEdit.framework/Versions/A/Resources/ObjectiveC.xclangspec

sudo rm /Applications/Xcode.app/Contents/OtherFrameworks/XcodeEdit.framework/Versions/A/Resources/ObjectiveC++.xclangspec

sudo rm /Applications/Xcode.app/Contents/OtherFrameworks/XcodeEdit.framework/Versions/A/Resources/C.xclangspec

---

This seems to be the alternate copy, and they will be used if you edit the primary in DVTFoundation.

You need to remove the caches *any time you edit* the langspecs, Xcode stashes everywhere:

---
 find /private/var/folders -name \*Xcode\* -print -exec rm -rf {} \;

 rm -rf ~/Library/Developer/Xcode/DerivedData
---


4. These highlighting rules are not yet compatible with context highlighting
(i.e. things that make your local class names pop out with a different color)
This needs some improvement.

5. MAKE BACKUPS AND USE AT YOUR OWN RISK

6. Sample colorschemes are included. They are just slammed together.
Copy colorschemes into:

---

cp *.dvtcolortheme \
~/Library/Developer/Xcode/UserData/FontAndColorThemes/

---


Again, this is tested with Xcode5 only. I have older highlighting
code that works for Xcode3. Xcode4, who knows. 

== Stuff you may want to know ==

   Things that were discovered in the process (if you want to improve this):

1. Xcode will crash if there is no ObjectiveC.xclangspec when you have
   ObjCC++ active.

2. ObjC++ is used for headers, and ObjC for m files. So the ObjC++ grammars
   also need editing.     

3. to refresh Xcode's syntax highlighting you need to do the following:

   a. stop Xcode
   b. save your edited files
   c. at the shell:

   rm -rf /private/var/folders/*/*/*/com.apple.DeveloperTools/*/Xcode*
   rm -rf ~/Library/Developer/Xcode/DerivedData
   open /Applications/Xcode5-DP5.app

   Unfortunately Xcode seems to cache the syntax highlighting from clang
   in the DerivedData somewhere. There also seems to be a cache in /private   
   so you need to nuke both. There may be a cleaner way to do it.

4. if keywords are shown at all in the ObjC lang spec then all the C
   keywords are automatically included (from somewhere...) seems like the
   only way to block it is to rename the grammar so it is not picked up.
   So basically the keywords list in the grammar does nothing, it cannot
   be changed, only the rules renamed.

5. Blocking out the keyword parsing by making a mismatch with the
   builtins causes all of the rest of the context-based parsing to fail out.

6. Xcode is very aggressive in loading langspecs, seems to load in subdirs and
   regardless of extension, so if you put something in there as a backup you
   will get two copies. So do not store any alternate versions of the grammar
   in Xcodes directory or else you will get strange results. 

7. do tail -f /var/log/system.log and watch Xcode errors... "line one"
   errors on the console mean that you have not closed a brace properly
   somewhere or broken the syntax in some other way. So make your changes
   in small iterations.

8. Visual Diff is very useful if you break the grammar, compare it against
   originals.

9. Keep backups of everything. Just not in the Xcode dirs.

10. It seems at the moment to be a choice between grammar highlighting and
    context recognition from clang/llvm. Anything in the grammar that
    clang/llvm cares about will be overridden. One of those things is
    identifiers, which are things we care about for highlighting method
    names. So if you use this highlighting, unless someone figures out
    how to do it, will override project/class identifying and highlighting
    as well as some other things based on context.

DBX Aug 2013

