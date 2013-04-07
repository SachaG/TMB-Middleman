---
layout: post
title: Using Meteor and Atmosphere on Windows
published: true
author: tom
---

# Using Meteor and Atmosphere on Windows

If you want to learn about Meteor and you are a Windows platform, you are a little out of luck. Unfortunately, as of this writing, Windows is not included on the list of [supported platforms](https://github.com/meteor/meteor/wiki/Supported-Platforms). However all is not lost. Read on intrepid traveller!

## A simple solution: use a VM

The simplest way around the problem is to run a virtual machine inside your Windows machine that runs a supported platform. Many Windows users are happily developing their windows code using [Ubuntu running inside VirtualBox](http://www.psychocats.net/ubuntu/virtualbox). Of course there are limitations with doing so, but it's probably the easiest way for now.

However if you are feeling especially intrepid, read on!

## Installing Meteor via the Windows MSI

Meteor community member [Tom Wijsman](https://github.com/TomWij) maintains a [Windows installer](http://win.meteor.com) for Meteor. He usually lags behind Meteor releases by a few days but all in all it's a good way to get working version of Metoer installed on your Windows machine. Please check the site for the latest installation instructions.

### Using atmosphere packages

If you've made it this far, you've got a running `meteor` executable on your OS and you're rearing to go. If you've spent much time in the community, you've probably realised that there's this awesome collection of 3rd party packages called [Atmosphere](http://atmosphere.meteor.com). To use Atmosphere packages, you need to run [Meteorite](http://oortcloud.github.com/meteorite/); but Meteorite doesn't run on Windows either! [^meaculpa]

Unfortunately, there's no great answer to this problem as of this writing. However, if you absolutely need to use them, the process is like this:

1. Move your application code into a subdirectory of your project (e.g. `/app`)
2. Create another subdirectory `/packages`.
3. Figure out what packages you need (remember that packages have dependencies, but you can see them on the package's atmosphere page. For example, [here](https://atmosphere.meteor.com/package/router) are the Router's dependencies). Alternatively, you can look in the app's `smart.lock` file in the `dependencies` section.
4. Install each package into `/packages`, directly from git.
  - NOTE: Many packages require you to run `git submodule update --init` inside them.
  - SECOND NOTE: most packages are named `meteor-X` in git (e.g. `meteor-router`), but need to be installed into a directory called `X`.
5. In your command window, run `set PACKAGE_DIRS=..\packages` to tell Meteor where to find packages
6. Run `meteor` where we tell you to run `mrt`.

This simulates, more or less, exactly what Meteorite does. So if you are following along with one of our examples, you should (just barely) be able to get things working.

We hope the situation will improve soon!!

[^meaculpa]: I can take the blame for this; but in my defence Meteorite heavily relies on installing Meteor from git, and there's a obvious problem when you need to install it via an MSI. Still, I think there'd be a way to get Meteorite working with Windows, although I don't have the MS chops to do it myself. If someone is keen, please [contact me](https://github.com/tmeasday/) and I'll be more than happy to assist!
