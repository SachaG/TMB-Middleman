---
layout: post
title: Getting Started with Meteor
published: true
author: tom
---

# Getting Started with Meteor

##### Level: Beginner

So you've heard of this [Meteor](http://meteor.com) thing and you are wondering what it's all about? 

Let's create a bare-bones application and have a play with it. Hopefully we'll learn a thing or two along the way.

## Installing Meteor: getting prepared

Getting off the ground with meteor couldn't be simpler. To install meteor, just run the following command 

{% highlight bash %}
curl https://install.meteor.com | /bin/sh
{% endhighlight %}

As long as you are running a [supported platform](https://github.com/meteor/meteor/wiki/Supported-Platforms), once you follow the steps, that should be it.

Let's make sure meteor is working on your machine. We'll create a simple app:

{% highlight bash %}
meteor create forum
{% endhighlight %}

If that works, we should be able to run the app by following the simple steps

{% highlight bash %}
cd forum
meteor
{% endhighlight %}

If everything has gone to plan, if you open up [http://localhost:3000](http://localhost:3000) in your browser, you should see something like:

<img src="/images/posts/bare-meteor-app.png"/>

## Setting up our forum

The simple application that meteor created for us doesn't really do much; it's more or less a demonstration of how to render templates and respond to events. 

However for today, we are just going to be using the browser console (i.e. the Chrome Inspector) to play with our app's data. So we don't need to worry too much about a user interface. Let's simplify things. We are just going to create  a collection of posts and display them in a list. To start, we write in forum.html:

{% handlebars %}
<head>
  <title>Forum</title>
</head>

<body>
  {{> posts}}
</body>

<template name="posts">
  <h1>Posts</h1>
  <ul>
    {{#each posts}}
      <li>{{name}}</li>
    {{/each}}
  </ul>
</template>
{% endhandlebars %}
{% caption forum.html %}

After making the edits to `forum.html`, you should see the browser window change as meteor automatically reloads the page. Now you should just see a blank page with the title "Posts". What's happened?

<img src="/images/posts/empty-posts-list.png"/>

We've used the `{%raw%}{{#each}}{%endraw%}` helper to tell meteor to draw a `<ul>` with a `<li>` for each `post`. But of course we haven't told it about any posts. So it is drawing nothing. So, let's make some posts!

In `forum.js`, we'll create a `Collection` called `'posts'`, and tell the `posts` template about it:

{% highlight js %}
Posts = new Meteor.Collection('posts');

if (Meteor.isClient) {
  Template.posts.helpers({
    posts: function() {
      return Posts.find();
    }
  })
}
{% endhighlight %}
{% caption forum.js %}

This might seem like a simple change, but it's not. What we've done is created a meteor [`Collection`](http://docs.meteor.com/#collections) client and server side called `'posts'`. What does that mean?

Server side, when documents are added to the collection, they will be written into a [mongo](http://www.mongodb.org) database (mongo comes bundled with meteor). When queries are executed, meteor will search that database. So we've got a persistent store for posts.

Client side, the `'posts'` collection automatically connects to the server and creates an in-browser, local mirror, or cache, of the server-side collection. So when documents are created in a browser, they are shuttled up to the server, who then inserts them in mongo, and transmits them out to _all other connected local `'posts'` collections_. Confused? You'll see what we mean soon enough.

Still, after making that change, you won't see any changes to our app; that's because we haven't added any data yet. Let's do that!

## Playing with data using the browser console

Let's take a closer look at this magic collection. We'll use the browser console; although we'll assume you are following along and using the Chrome Inspector, any other browser console (such as Firebug, etc.) should serve same purpose.

First off, let's take a look at what's in the collection. Let's run the code that we used to tell the `posts` template to query the collection for data:

    Posts.find()
    » ‣LocalCollection.Cursor

A `Cursor` is a meteor data source which lazily returns data matching the query it was given (an empty query in our case). It's not so interesting for us now, so let's extract the data out of it with:

    Posts.find().fetch()
    » []

That call should return an empty array `[]`. That's because there are no posts. So let's add one!

 {% highlight js %}
 Posts.insert({name: 'A Brand New Post'});
 {% endhighlight %}

Instantly, we see a post appear in the page, as Meteor's reactive rendering keeps the HTML in sync with the underlying data model. 

<img src="/images/posts/single-post-inserted.png"/>

But wait, there's more; we can now fetch the post out of the collection in the client:

    Posts.find().fetch()
    » [‣Object]

We can see that the post is now living in the local collection. Not so impressive? Try refreshing the browser; or open [http://localhost:3000](http://localhost:3000) in another tab. The post in still there.

What's happened? Behind the scenes, meteor has synchronised that post object (`{name: 'A Brand New Post'}`) up to the server, saved in into the mongo db, and is now distributing it to all clients that ask for posts. We can also see it in the mongo console; try running `meteor mongo` on the command line (while meteor is still running in another terminal), and you can use a similar interface:

{% highlight js %}
> db.posts.find()
{ "name" : "A Brand New Post", "_id" : "a72d6722-262b-4dc5-80f6-564796a6cc95" }
{% endhighlight %}

Take a moment to consider how great it is that this is wired up for you (with no work on your part!), and then go nuts playing with the `insert`, `update` and `remove` commands ([documentation here](http://docs.meteor.com/#collections)) in one browser while watching things synchronise across to another (on another machine if you can set that up).

Next time we'll show you how to start building a real, functional application on the back of this simple, yet powerful collection. 