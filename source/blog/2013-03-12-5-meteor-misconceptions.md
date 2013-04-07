---
title: 5 Meteor Misconceptions
published: true
author: sacha
---

# 5 Meteor Misconceptions

For some reasons there are a lot of misconceptions floating around about Meteor. Maybe this is because when Meteor initially launched, it was missing a few key features, and many people are not aware that these shortcomings have long since been patched up. 

So to clear the air, here are the five most common myths about Meteor:

## Myth #1: "Meteor doesn't have data security"

When the first Meteor demo initially came out, security and user permissions were nonexistent. All of the database's data was sent up to every client, where anybody could access it, modify it, and send it back down the pipe to the server.

But that first version was just a hint of things to come, and was never meant to be used to build an actual production app. Things have changed since then, and Meteor now has a full built-in authentication package.

Another source for the misunderstanding is that newly created Meteor apps *do* publish all their data to the client by default, to make it easier for you to get started quickly. 

As Meteor dev Avital Oliver [answered on StackOverflow](http://stackoverflow.com/questions/10099843/how-secure-is-meteor):

> When you create a app using meteor command, by default the app includes the following packages: AUTOPUBLISH and INSECURE.
> Together, these mimic the effect of each client having full read/write access to the server's database. These are useful prototyping tools (development purposes only), but typically not appropriate for production applications. When you're ready for production release, just remove these packages.

Similarly, just because Meteor apps have the ability to share code between client and server doesn't mean *all* code is made available to the client. 

Anything you include in the `server/` directory will remain strictly [on the server]((http://docs.meteor.com/#structuringyourapp),  and Meteor also lets you define [secure server-side methods](http://docs.meteor.com/#methods_header) that you can then invoke from the client. 

## Myth #2: "Meteor is bad for SEO"

Unlike a traditional web app, Meteor doesn't (yet) build HTML pages on the server. Instead, it sends over the data and lets the client decide what to with it (the "data on the wire" principle). 

The downside of this approach is that with JavaScript disabled, your site will be little more than a blank page. 

You might think this would confuse search engines, but thankfully Meteor includes a workaround in the form of the [Spiderable](http://docs.meteor.com/#spiderable) package.

<div class="image"><img src="/images/phantomjs.png"/></div>
{% caption PhantomJS %}

This package uses [PhantomJS](http://phantomjs.org) to pre-render pages server-side and serve them to crawlers, in effect showing them the same site that your visitors would see. 

## Myth #3: "Meteor doesn't support third-party packages"

There's been a lot of talk about the fact that Meteor does not use Node's standard package manager, NPM. In fact, you might be forgiven for believing that Meteor does not permit third-party packages at all.

And it's true that the vanilla install of Meteor does not come with a package manager. Thankfully, The Meteor Book co-author Tom Coleman is also the man behind [Meteorite](https://github.com/oortcloud/meteorite), a package manager for Meteor, as well as [Atmosphere](http://atmosphere.meteor.com), a repository of said packages. 

While Meteorite and Atmosphere are not yet officially part of Meteor, they're widely used and will be merged into the Meteor core at some point in the future. In fact, work in this direction has begun in the `engine` branch of Meteor core, due to be released soon.

## Myth #4: "Meteor is a walled garden"

A closely related objection is that while Meteor might support third-party packages, those packages are strictly limited to the Meteor ecosystem. 

Why use custom packages in the first place when thousands of Node packages are already out there? Isn't this going against the spirit of open-source?

Firstly, it's important to realize that it _is_ possible to use arbitrary node packages with Meteor. There are some rough edges in doing so right now, but many of those should be smoothed over due to the addition of [NPM support](https://groups.google.com/forum/?fromgroups=#!topic/meteor-talk/b6zQrgk8lYo) in the upcoming `engine` release.

<div class="image"><img src="/images/npm.png"/></div>
{% caption NPM %}

Secondly, Meteor is not just a Node.js framework, but a whole new way of conceiving and developing web apps. The reason a lot of packages are Meteor-only is simply that they only make sense in the context of Meteor. 

Put another way, wondering why Meteor can't use NPM packages out of the box isn't that different from asking why it can't use Ruby Gems. There are some that suggest _all_ javascript code should be in NPM, but there are some specific issues with doing so, as core dev Geoff Schmidt [explained](https://github.com/meteor/meteor/pull/516#issuecomment-12919473).

## Myth #5: "Meteor is only for prototyping"

"Meteor is nice for small side projects and quick prototypes, but it shouldn't be used for larger-scale production apps". 

In a way, it's hard to argue against this. After all the version number at the top of the Meteor homepage still starts with "0".

But the fact that Meteor is not quite ready for primetime yet has a lot more to do with its young age (not quite one year old) than any inherent limitations.

Then again, even right now it's sometimes worth trading of a little stability for the quickness and ease of development brought by Meteor. And if you want to see a concrete example of what can be done right now with Meteor, might I suggest taking a look at [Telescope](http://telesc.pe)? 

So I firmly believe that with the speed at which Meteor is evolving, the prototypes of today will be the thousand-user apps of tomorrow. 

## Conclusion

Now even though we might be writing a book about Meteor, we'll be the first to admit that, like every other technology, it has its downsides as well. 

But I do believe Meteor has enough potential to make it worth evaluating it on its own merits. So if you were hesitant to try out Meteor before, hopefully I was able to convince you to give it a second chance!