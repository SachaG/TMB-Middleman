---
layout: post
title: A Look at a Meteor Template
author: sacha
published: true
---

# A Look at a Meteor Template

##### Level: Beginner

Building a simple app from scratch is one of the best ways to learn a new language or framework. 

But after your sixth time building a to-do list app, you start craving something new. So for once, let's look at some code from an *actual* app, in this case [Telescope](http://telesc.pe).

Telescope is an open-source social news app built with Meteor. Think your own [Reddit](http://reddit.com) or [Hacker News](http://news.ycombinator.com), but real-time. 

The code we'll look at is a simplified version of the `post_edit` [template](https://github.com/SachaG/Telescope/blob/master/client/views/posts/post_edit.html) and its [controller](https://github.com/SachaG/Telescope/blob/master/client/views/posts/post_edit.js). At its name indicates, this template's role is providing a simple form for editing an existing post. A post has a title, URL, body, and one or more categories. The actual form has a few more extra field, but we won't worry about them today:

<div class="image"><img src="/images/telescope-post-edit.png"/></div>
{% caption Telescope's post edit form, with a few extra fields %}

The goal of this article is giving you a basic overview of how Meteor templates work. This will already be familiar if you've used templating systems in other environment, but if not then let's get started!

## Basic Organization

Meteor templates have two parts: the HTML template and Javascript controller. The HTML part is just a dumb template with placeholders for variables, while the real action happens over on the Javascript side as you'll soon see. 

By the way, Meteor gets the name of a template from the name attribute (`<template name="post_edit">`), and I recommend you adopt the convention of naming both files after the template itself, which in this case gives us `post_edit.html` and `post_edit.js`. 

{% handlebars %}
<template name="post_edit">
  {{#with post}}
    <form>
      <div>
        <label>Title</label>
        <input id="title" type="text" value="{{headline}}" />
      </div>
      <div>
        <label>URL</label>
        <input id="url" type="text" value="{{url}}" />
      </div>
      <div>
        <label>Body</label>
        <textarea id="body" value="" class="input-xlarge">{{body}}</textarea>
      </div>
      <div>
        <label>Category</label>
        {{#each categories}}
          <label class="checkbox inline">
            <input id="category_{{_id}}" type="checkbox" value="{{_id}}" name="category" {{hasCategory}} /> {{name}}
          </label>
        {{/each}}
      </div>
      <div class="form-actions">
        <a class="delete-link" href="/posts/deleted">Delete Post</a>
        <input type="submit" value="Submit" />
      </div>
    </form>
  {{/with}}
</template>
{% endhandlebars %}
{% caption post_edit.html template %}

{% highlight js %}
Template.post_edit.helpers({
  post: function() {
    return Posts.findOne(Session.get('selectedPostId'));
  },
  categories: function() {
    return Categories.find().fetch();
  },
  hasCategory: function() {
    var post = Posts.findOne(Session.get('selectedPostId'));
    return _.contains(post.categories, this.name) ? 'checked' : '';
  }
});

Template.post_edit.events = {
  'click input[type=submit]': function(e) {
    e.preventDefault();

    var selectedPostId = Session.get('selectedPostId');
    var post = Posts.findOne(selectedPostId);

    var categories = [];
    $('input[name=category]:checked').each(function() {
      categories.push($(this).val());
    });
    
    var properties = {
      title:         $('#title').val(),
      url:           $('#url').val()
      body:          $('#body').val(),
      categories:    categories,
    };

    Posts.update(selectedPostId, {$set: properties}, function(error) {
      if (error) {
        alert(error.reason);
      }
    });
  },
  'click .delete-link': function(e) {
    e.preventDefault();
    if(confirm("Are you sure?")) {
      var selectedPostId = Session.get('selectedPostId');
      Posts.remove(selectedPostId);
    }
  }
};
{% endhighlight %}
{% caption post_edit.js controller %}

That might seem like a lot to take in, but once we break it down you'll see that it's actually very easy to understand even if you've never laid eyes on Meteor code before. 

## Handlebars Tags

Let's take a quick look at the HTML. You've probably noticed the weird-looking tags. Those are [Handlebars](http://handlebarsjs.com/) tags and let us display dynamic data. 

The first handlebars tag is {% raw %}<code>{{#with post}}</code>{% endraw %}: 

{% handlebars %}
<template name="post_edit">
  {{#with post}}
    <!-- do something with "post" -->
  {{/with}}
</template>
{% endhandlebars %}
{% caption The "with" block helper %}

This [block helper](http://handlebarsjs.com/block_helpers.html) is a shortcut to tell our template what object we want to be working on. Inside that {% raw %}<code>{{#with}}</code>{% endraw %} block, our app will understand that `this` means `post`. That `this` is know as the "data context" of the method. 

## Template Helpers

You might be wondering where we're getting that `post` from. Let's take a look at your controller to find out:

{% highlight js %}
Template.post_edit.helpers({
  post: function() {
    return Posts.findOne(Session.get('selectedPostId'));
  }
});
{% endhighlight %}
{% caption The "post" template helper %}

What we're doing here is adding a `post` [template helper](http://docs.meteor.com/#template_helpers) to our `post_edit` template. Template helpers are simply Javascript methods that are you make available to the Handlebars template. 

In this case, whenever our Handlebars template calls `post` we'll look for the current post in our `Posts` collection and return it. To do this we use the `selectedPostId` Session variable which is set by the router (but that's for another lesson). 

## Object Properties

Moving on, the second tag we encounter is {% raw %}<code>{{title}}</code>{% endraw %}:

{% handlebars %}
<div>
  <label>Title</label>
  <input id="title" type="text" value="{{title}}" />
</div>
{% endhandlebars %}
{% caption The "title" template helper %}

Although you have no way to tell just by the syntax, this {% raw %}<code>{{title}}</code>{% endraw %} tag is not a template helper but simply one of our `post` object's properties, which Meteor magically makes available to us for use without any extra work. 

## Nested Objects

The URL and Body form fields follow the same pattern, but our Category field is a little different. Here, we want to display a list of checkboxes for all of the site's pre-defined categories with the correct categories checked off.

The first part of the job is laying out a list of categories, and we do this using the handy {% raw %}<code>{{#each categories}}</code>{% endraw %} block helper:

{% handlebars %}
<div>
  <label>Category</label>
  {{#each categories}}
    <label class="checkbox inline">
      <input id="category_{{_id}}" type="checkbox" value="{{_id}}" name="category" {{hasCategory}} /> {{name}}
    </label>
  {{/each}}
</div>
{% endhandlebars %}
{% caption Looping over categories with the "each" helper %}

This helper does two things: it iterates over the `categories` object, and it tells the template to use the resulting iterated element as `this` inside the block. 

As you guessed, `categories` is a template helper just like `post` was. In this case we're just returning a list of all our categories from the database:

{% highlight js %}
  categories: function() {
    return Categories.find();
  }
{% endhighlight %}
{% caption The "categories" template helper %}

Remember when I said that the block helper changed the value of `this`? That's why we can use {% raw %}<code>{{_id}}</code>{% endraw %} here without fear of confusion. We're inside the block helper so we're dealing with the category's ID, not the post's.

## More Helpers

Up to now our helpers have simply been querying our collections and returning data. But helpers are not limited to this by any means. Let's take a look at the {% raw %}<code>{{hasCategory}}</code>{% endraw %} helper:

{% highlight js %}
hasCategory: function() {
  var post = Posts.findOne(Session.get('selectedPostId'));
  return _.contains(post.categories, this.name) ? 'checked' : '';
}
{% endhighlight %}
{% caption The "hasCategory" template helper %}

Remember that we're calling this helper from within the {% raw %}<code>{{#each categories}}</code>{% endraw %} block, which means that `this` represents a category.

So we're first getting our current post object, and then checking to see if the current category is contained in the post's categories. If it is, we simply return the "checked" string to mark our checkbox as checked. 

You might have noticed that `_.contains()` is an [Underscore](http://underscorejs.org) method. Underscore is a very useful Javascript toolkit and is handily bundled with Meteor. 

## Template Events

We now have enough code to load a post's title, URL, body, and categories. But we still need a way to save our edit form. This is where template events come in:

{% highlight js %}
Template.post_edit.events = {
  'click input[type=submit]': function(e) {
    // do something when the users clicks input[type=submit]
  },
  'click .delete-link': function(e) {
    // do something when the users clicks .delete-link
  }
};
{% endhighlight %}
{% caption Template events %}

As you can see, defining template events is as simple as putting an event and a CSS selector together. We have two event handlers here, one for submitting the form and one for deleting our post. 

Let's first take a look at the form submission handler:

{% highlight js %}
'click input[type=submit]': function(e) {
  e.preventDefault();

  var selectedPostId = Session.get('selectedPostId');
  var post = Posts.findOne(selectedPostId);

  var categories = [];
  $('input[name=category]:checked').each(function() {
    categories.push($(this).val());
  });
  
  var properties = {
    title:         $('#title').val(),
    url:           $('#url').val()
    body:          $('#body').val(),
    categories:    categories,
  };

  Posts.update(selectedPostId, {$set: properties});
},
{% endhighlight %}
{% caption Our form submit handler %}

The handler method takes two arguments, the event and the template instance. We can ignore the template instance for now, but it's a good idea to start off your handler with `e.preventDefault();` to prevent the browser from executing the event's default behavior.

You'll noticed a lot of `$` thrown in here. In addition to Underscore, Meteor also bundles in [jQuery](http://jquery.com). See, it's like you actually know half of Meteor already!

Once again, dealing with categories is a little trickier than the rest. Using jQuery, we're checking for checked checkboxes (try saying that 10 times!) and filling an array with their IDs. 

We can then build our `properties` object and simply use Meteor's [update()](http://docs.meteor.com/#update) method to submit our changes back to the database.

Deleting a post is even easier:

{% highlight js %}
'click .delete-link': function(e) {
  e.preventDefault();
  if(confirm("Are you sure?")) {
    var selectedPostId = Session.get('selectedPostId');
    Posts.remove(selectedPostId);
  }
}
{% endhighlight %}
{% caption Our post delete handler %}

We simply pass the correct ID to Meteor's [remove()](http://docs.meteor.com/#remove) method and we're done!

## Other Callbacks

Meteor provides a couple other callbacks to manage templates, such as the [created](http://docs.meteor.com/#template_created) and [rendered](http://docs.meteor.com/#template_rendered) callbacks. 

Although we're not using them here, the rendered callback comes in particularly handy to do DOM manipulation with jQuery once Meteor is done rendering a template.

## Conclusion

CRUD (Create, Read, Update, Delete) operations often make up the bulk of a web app's functionality. So the fact that Meteor makes them so easy is a definite plus!

What's more, Meteor code relies on a lot of familiar patterns and libraries, which means you can get up to speed extremely quickly with minimal Javascript experience. 

Of course, as your needs evolve you'll need to dig deeper into the intricacies of the framework. But even if you only know about Meteor's most basic features you can still create something, and I really think that's what makes it such a fun environment to play with! 