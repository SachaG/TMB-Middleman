### Displaying posts in order

The point of all this is to display the posts in the right order, so let's change the `posts` controller to return the posts in the right order. To do so, we'll use the mongo `sort` operator:

```js
Template.posts.helpers({
  posts: function() {
    return Posts.find({}, {sort: {votes: -1}});
  }
});
```
<%= caption "client/views/posts/posts_top.js" %>

Give it a try. Signup up for a few accounts in a few anonymous browser tabs, vote for some posts, and see if you can watch the order of the posts change, instantly across all browsers. Pretty cool!

Actually having posts change order instantly isn't ideal, as it's if you blink you might miss it! In the next chapter, we'll *animate* the posts when they change position, and hopefully make things much clearer. In the meantime, there are a few improvements we can make.



---------------


### Stopping cheating

If you've been paying attention and are quick on your feet, you may have realized a flaw in our system. What's to stop a user from tweaking the total number of votes on one of their own posts? Give it a try: figure out the `id` of one of your own posts (just look in the URL), preferably one that's languishing at the bottom of the post list, and try a little hack:

How are we allowed to do this? Well, when we specified the `allow` rules for updating posts, we only said that a user can only edit *their own posts*, but never anything about *how*! 

Luckily, the problem is easily solved with the addition of a `deny` rule:
```js
  Posts.deny({
    update: function(userId, doc, fields) {
     return _.contains(fields, 'votes') || _.contains(fields, 'upvoters');
  });
```
<%= caption "lib/posts.js" %>

An `update` rule receives as third argument a set of the fields that are going to be modified. We simply take a look to see if `votes` or `upvoters` are included there, and return `true` (i.e. that we should deny this change) if so.

Considering that our edit post form never touches those fields, we've solved the problem nicely. Try the little hack again on another one of your posts:

```js
  Posts.update(postId, {$set: {votes: 10000}});
  >> SOME ERROR MESSAGE
```
<%= caption "browser console" %>

-----------



If you switch from page to page now you'll see that all posts will fade in. While this looks nice, it's a little bit counter-productive since the goal of our animation is to highlight "new" posts (i.e. those who appear after page load). So we want to limit our animation to these newly inserted elements, but for that we first need to define what "new" means. 

To do this, we'll use a Session variable to set a timestamp inside a router filter, and we'll then be able to declare that any template created after that timestamp is "new". 

```js

Meteor.Router.filters({
  'requireLogin': function(page) {
    if (Meteor.user())
      return page;
    else if (Meteor.loggingIn())
      return 'loading';
    else
      return 'accessDenied';
  },
  'clearErrors': function(page) {
    clearUnseenErrors();
    return page;
  },
  'setTimestamp' : function(page) {
    Session.set('pageLoadTimestamp', new Date());
    return page;
  }
});

Meteor.Router.filter('requireLogin', {only: 'postSubmit'});
Meteor.Router.filter('clearErrors');
Meteor.Router.filter('setTimestamp');
```
<%= caption "/client/lib/router.js" %>

We can now update our `rendered` callback to take that timestamp into account:

```js
 if(instance.currentPosition){
    var previousPosition = instance.currentPosition;
    // calculate difference between old position and new position and send element there
    var delta = previousPosition - newPosition;
    $this.css("top", delta + "px");
  }else{
    // it's the first ever render
    var postTimestamp = instance.data.submitted;
    var pageLoadTimeStamp = Session.get('pageLoadTimestamp');
    if(postTimestamp > pageLoadTimeStamp){
      // the post has been submitted after the initial page load, so we hide it
      $this.addClass("invisible");
    }
  }
```
<%= caption "/client/views/posts/postItem.js" %>

In plain english, all we're saying is that if a post is created (`instance.data.submitted`) after the page has loaded, then we want to hide it. 


------------

tag.html

---
pageable: true
per_page: 12
---
<h1>Articles tagged '<%= tagname %>'</h1>

<% if paginate %>
  <p>Page <%= page_number %> of <%= num_pages %></p>

  <% if prev_page %>
    <p><%= link_to 'Previous page', prev_page %></p>
  <% end %>
<% end %>

<ul>
  <% page_articles.each_with_index do |article, i| %>
    <li><%= link_to article.title, article %> <span><%= article.date.strftime('%b %e') %></span></li>
  <% end %>
</ul>

<% if paginate %>
  <% if next_page %>
    <p><%= link_to 'Next page', next_page %></p>
  <% end %>
<% end %>


------

<%= diagram "meteor_files","A typical Meteor app file structure" %>
