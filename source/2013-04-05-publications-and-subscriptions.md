---
layout: post
title: Publications and Subscriptions
published: false
author: tom
---

# Publications and Subscriptions

##### Level: Intermediate

Publications and subscriptions are some of the most fundamental and important concepts in Meteor, but can be the most difficult to understand. This is mostly because what they are doing is foreign to developers who are used to more traditional ways of building for the web. 

We are used to defining and thinking about our own APIs for passing data between client and server, but in Meteor data is synchronized for us. We use publications to control exactly _how_.

Part of the reason people find the concept a bit confusing initially is the "magic" that Meteor does for us. Although this magic is ultimately very useful, it can obscure what's going on behind the scenes (as magic tends to do). So, let's strip away the layers of magic to try and understand what's happening. We'll learn a trick or two along the way.

## Defining Publications

Fundamentally a **publication** (which we connect to using a **subscription**) is a method of transferring data from a server-side (source) collection to a client-side (target) collection. Think of the subscription as a funnel  connecting the canonical data store (the source collection, which talks to the mongo data-store) and the client-side cache (the target collection, which represents a copy or a subset of that data). 

The subscription controls exactly what data passes through that funnel, and takes care of synchronizing the data between either end. By attaching multiple subscriptions to the server's data-store, we are able to keep multiple browser's view of the data in-sync, *efficiently*, *securely* and *in real-time*.

The protocol that is spoken over that tunnel is called DDP (which stands for Distributed Data Protocol). To learn more about DDP, you can watch [this talk from The Realtime Conference](http://2012.realtimeconf.com/video/matt-debergalis) by Matt DeBergalis (one of the founders of Meteor), or [this screencast](http://www.eventedmind.com/posts/meteor-subscriptions-and-ddp) by Chris Mather that walks you through this concept in a little more detail.


Now that we've established the basics, let's dive in. 

## Autopublish

If you create a Meteor project from scratch (i.e using `meteor create`), it will automatically have the `autopublish` package enabled. As a starting point, let's think about what it does exactly.

Depending on how you look at it, `autopublish` either removes the need for subscriptions or simply takes care of them for you. What autopublish does is automatically mirrors _all data_ from the server on the client.

{% image pullcenter /images/book/autopublish@2x.png "Autopublish" %}

How does this work? Suppose you have a collection called `'posts'` on the server. Then autopublish will automatically send every post that it finds in the Mongo posts collection into a collection called `'posts'` on the client (assuming there is one).

So if you are using autopublish, you don't need to think about subscriptions. Data is ubiquitous, and things are simple. Of course, there are obvious problems with having a complete copy of your app's database cached on every user's machine. 

For this reason, autopublish is only appropriate when you are starting out, and haven't yet thought about subscriptions.

## Publishing Full Collections

Once you remove autopublish, you'll quickly realize that all your data has vanished from the client. An easy way to get it back is to simply duplicate what autopublish does, and publish a collection in its entirety. For example:

{% highlight js %} 
Meteor.publish('allPosts',function(){
  return Posts.find();
});
{% endhighlight %}

{% image pullcenter /images/book/fullcollection@2x.png "Publishing a full collection" %}

We're still publishing full collections, but at least we now have control over which collections we publish or not. In this case, we're publishing the `Posts` collection but not `Comments`. 

## Publishing Partial Collections

The next level of fine-grained control is publishing only _part_ of a collection, for example only the posts that belong to a certain author:

{% highlight js %} 
Meteor.publish('somePosts',function(){
  return Posts.find({'author':'Tom'});
});
{% endhighlight %}

{% image pullcenter /images/book/partialcollection@2x.png "Publishing a partial collection" %}

The code is easy enough, but what's going on exactly behind the scenes?

If you've read the [Meteor docs](http://docs.meteor.com/#publishandsubscribe), you were probably overwhelmed by talk of using `added()` and `ready()` to set attributes of records on the client, and struggled to square that with the Meteor apps that you've seen that never use those methods.

The reason for this is a very important convenience that Meteor provides -- the `_publishCursor()` method. You've never seen that used either? Perhaps not directly, but if you return a **cursor** (i.e. `Posts.find({'author':'Tom'})`) in a publish function, that's exactly what is going on.

When meteor sees that the `somePosts` publication has returned a cursor, it calls `_publishCursor()` to (you guessed it) publish that cursor automatically. Here's what `_publishCursor()` does:

- it checks the name of the server-side collection.
- it pulls all matching documents from the cursor and sends it into a client-side collection *of the same name*. (It uses `.added()` to do this).
- whenever a document is added, removed or changed, it sends those changes down to the client-side collection. (It uses `.observe()` on the cursor and `.added()`, `.updated()` and `removed()` or to do this).

So in the example above, we are able to make sure that the user only has the posts that they are interested in (the ones written by Tom) available to them in their client side cache. Handy.

## Publishing Partial Properties

We've seen how to only publish some of our posts, but we can keep slicing thinner! Let's see how to only publish specific _properties_. 

{% image pullcenter /images/book/partialproperties@2x.png "Publishing partial properties" %}

Just like before, we'll use `find()` to return a cursor, but this time we'll exclude certain fields:

{% highlight js %}
Meteor.publish('allPosts',function(){
  return Posts.find({}, {fields: {
    author: false
  }});
});
{% endhighlight %}

Of course, we can also combine both techniques. For example, if we wanted to return all posts by Tom while leaving aside their date, we would write:

{% highlight js %}
Meteor.publish('allPosts',function(){
  return Posts.find({'author':'Tom'}, {fields: {
    author: false
  }});
});
{% endhighlight %}

## Summing Up

So we've seen how to go from publishing every property of all documents of every collection (with `autopublish`) to publishing only _some_ properties of _some_ documents of _some_ collections.

This covers the basics of what you can do with Meteor subscription, and these simple techniques should take care of the vast majority of use cases. 

Sometimes, you'll need to go further by combining, linking, or merging publications. But we'll leave that for another time!