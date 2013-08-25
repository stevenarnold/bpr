bpr
===

This is the Blood Pressure Reducer app on the iTunes App Store, rewritten
in RubyMotion.  Note that you must have a copy of RubyMotion to compile and
run the app.  RubyMotion is a commercial app, but there is a demo period.

Note I used ruby-1.9.3-p392 in rvm for this project, but I have no
reason to believe, e.g., Ruby 2.x wouldn't work.  You definitely need a
late 1.9 version, because we use the symbol: value syntax (as opposed to
the old-fashioned name => value syntax).

To compile, first install XCode and RubyMotion.  Then, if you choose to
use rvm, you can follow these steps:

prompt> rvm gemset create bpr
prompt> rvm use <my-installed-ruby>@bpr
prompt> bundle

Then, to run the app in the simulator:

prompt> rake

CONTRIBUTIONS & CODE QUALITY
============================

BPR is always a work in progress.  The app could, no doubt, benefit from many
improvements, both in code design, features added, and bugs fixed.  Please
feel free to fork the code, make changes, and request that I pull them in.
The more you can describe what you did and why, the better I will be able to
decide whether I want that code in the trunk.  Before making a major change, it
might be a good idea to write to me at:

  stevena+dev.feedback@arnold-software.com

so that we can discuss the ideas.  I consider myself accessible and receptive
to good ideas, so please don't hesitate to reach out if you have ideas that
you think are good, even things you'd like that you don't intend to develop
yourself.

To keep copyright issues simple, before I will pull a fork or include a patch
from another developer, the developer must sign a document that gives both him
or herself, and myself, Steven D. Arnold, and my company, Arnold Software
Associates, full copyright ownership of all patches accepted into the BPR
project.  If accepted, I promise to release your changes under the GPL v3, with
my additional restrictions below, and you will retain full copyright ownership
of the code you wrote.  But, I and Arnold Software Associates will also receive
full copyright ownership, and we may therefore do anything with that code in
future products, without (for example) necessarily releasing those future
products under the GPL.  You, of course, could do the same thing with the code
you contributed.

I realize signing a document and returning it is a hassle, but I think it's a
small one, and it will greatly simplify future license management of the code.
I can promise you that BPR is and always will be under the GPL v3 or a future
version.  If I sell BPR to someone else, they will be bound legally to honor
that promise as well.

REPORTING ISSUES & FEATURES
===========================

Although I enjoy hearing from users and fellow developers, it's a good idea to
submit both bug reports and feature requests using the issues feature of
github.  Go to the project page, click Issues in the panel on the right, click
New Issue, and describe the problem or desired new feature in as much detail
as possible, including any and all research you may have done in the issue. If
it's a bug, what were you doing that led up to the bug?  Does it happen all
the time or only under certain conditions?  Under those conditions, is it 100%
repeatable or intermittent?  What happens if you quit the program and come
back?  What if you turn off your phone and come back?  These kinds of answers
can help a lot in diagnosing and fixing a problem.

LOOK AND FEEL
=============

I can appreciate a beautiful user interface very much, like most of us.  But,
I am much better at developing rather than designing user interfaces.  The
current version of BPR on Github is very Spartan.  I'll do some things to
improve that, but I would really value feedback on how to improve the user
experience.

FUTURE DIRECTION
================

I would like to allow users to save a program and call it back up easily.  For
example, one program may last 15 minutes and take you to 6.5 breaths per
minute, while another lasts for 30 minutes and takes you to 5.5 breaths per
minute.

I would like a feature that allows a user to continue the program after it has
ended, for a time of their choice.  If the program was set for 10 minutes but
you wish to keep going, we just pick up where we left off for, say, another 15
minutes.

Currently we use the Golden Ratio algorithm for in/out breath lengths: as the
program progresses, the time for in breaths to out breaths approaches 1 ::
1.61. I would at least like to add an option to have a 1 :: 1 ratio, and if
other ratios are thought useful, they may be added as well.  The classic
version of BPR aimed for 1 :: 1.  I switched to the Golden Ratio because for
me, out breaths usually take longer than in breaths, and it feels a little
unnatural for them to take exactly the same amount of time.

I would like to allow the user to select multiple ending sounds, including no
ending sound at all (except the ambient sounds, bells and binaural tones all
stop).

I would like the user to have an option to pick from among several sets of in-
out bells or tones.  I would also like the user to be able to select different
binaural programs.  Right now, there's just the one.

I would like to port this program to Ruboto and run it on Android, refactoring
as necessary to make this as painless as possible.  This may mean adding a
layer in the code that determines how to do various things based on whether a
given setting is Android or iOS.

It would be nice if the user could adjust how quickly or slowly breathing
rates increased or decreased, and how quickly or slowly in and out breath
ratios moved toward the target.

