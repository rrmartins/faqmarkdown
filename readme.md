# Faqmarkdown

A simple Rails FAQ engine powered by Markdown.

Faqmarkdown is compatible with Rails 3 only and the gem is hosted on [RubyGems.org](http://rubygems.org/gems/faqmarkdown).

## Features

* Markdown files for faq
* No database
* RSS Feed
* Customizable Routes
* Built-in minimal theme (optional)
* HTML5
* Rails engine (so you can override models, views, controllers, etc)
* Easily customized

## Installation

Simply add Faqmarkdown to your Gemfile and bundle it up:

    gem 'faqmarkdown'

Then, run the generator to setup Faqmarkdown for your application:

    $ rails generate faqmarkdown:install

The above command performs the following actions:

* Create the directory `app/faqs/`. This directory is where your markdown files will live.
* Generate an example faq using today's date, eg. `app/faqs/2011-01-01-example-faq.markdown`.
* Add some routes. By default the routes are setup underneath the path `/faqs/*`, to customize these routes check out the Customizing Routes section below.

## Usage

### Generate a new Faq

Here's an example of how to generate a new faq using a slug and publish date:

    $ rails generate faqmarkdown:faq test-faq --date=2011-01-01

The above command will create the file `app/faqs/2011-01-01-test-faq.markdown`, which you can edit and add content to.

### Creating a brief summary

In their markdown, place the tag below, and everything above it will appear at the summary of your faq.

Tag:

    <!--more-->

### Faq to categories

To put your faq in some categories, use:

    categories:
       - foo
       - bar

This is an Array of their categories in the faq.

To list all categories, use:

    faq.categories_all

This will return:

    ["foo", "bar"]

To do a search for a particular category, do:

    faq.find_by_category ('foo')

This will return your faqs that have a category named `foo`.

### View the faq

Open `http://localhost:3000/faqs` in your browser and you should be able to navigate to your new faq. The URL for your new faq is `http://localhost:3000/faqs/2011/01/01/test-faq`.

## Overriding Files

The easiest way to customize the Faqmarkdown functionality or appearance is by using the override generator. This generator can copy files from the Faqmarkdown core and place them into your Rails app. For example:

    $ rails generate faqmarkdown:override --all        # overrides all of the things
    $ rails generate faqmarkdown:override --controller # overrides `app/controllers/faqs_controller.rb`
    $ rails generate faqmarkdown:override --model      # overrides `app/models/faq.rb`
    $ rails generate faqmarkdown:override --views      # overrides all files in directory `app/views/faqs/`
    $ rails generate faqmarkdown:override --theme      # overrides the layout and stylesheet

## RSS Feed

Faqmarkdown comes prepared with a fully functional RSS feed.

You can take advantage of the built-in feed by adding the feed link to your HTML head tag. For example, simply add the following to your default layout:

    <head>
      <!-- include your stylesheets and javascript here... -->
      <%= yield :head %>
    </head>

To customize the feed title, add the following to an initializer (`config/initializers/faqmarkdown.rb`):

    Faqmarkdown::Config.options[:feed_title] = 'Custom Faq Title Goes Here'

To link to the feed in your app, simply use the route helper: `<%= link_to 'RSS Feed', faqs_feed_path %>`

## Customizing the layout

By default, Faqmarkdown will use your application's default layout, but if you wish to use a specific custom layout, you can set the following configuration in an initializer (`config/initializers/faqmarkdown.rb`):

    Faqmarkdown::Config.options[:layout] = 'layout_name'

### Built-in Theme

Faqmarkdown comes with minimal built-in theme for your convenience.

    Faqmarkdown::Config.options[:layout] = 'faqmarkdown'

## Customizing Routes

By default Faqmarkdown will setup all routes to go through the `/faqs/*` path. For example:

    http://example.com/faqs                      # lists all faqs
    http://example.com/faqs/2011                 # lists all faqs from 2011
    http://example.com/faqs/2011/01              # lists all faqs from January 2011
    http://example.com/faqs/2011/01/01           # lists all faqs from the 1st of January 2011
    http://example.com/faqs/2011/01/01/test-faq # show the specified faq

You can change the default route path by modifying the 'faqmarkdown' line in `routes.rb`. For example:

    faqmarkdown :as => :faq

This will produce the following routes:

    http://example.com/faq                      # lists all faqs
    http://example.com/faq/2011                 # lists all faqs from 2011
    http://example.com/faq/2011/01              # lists all faqs from January 2011
    http://example.com/faq/2011/01/01           # lists all faqs from the 1st of January 2011
    http://example.com/faq/2011/01/01/test-faq # show the specified faq

You can also customize the `faqs#show` route via the `:permalink_format` option:

    faqmarkdown :as => :faq, :permalink_format => :day   # URL: http://example.com/faq/2011/01/01/test-faq
    faqmarkdown :as => :faq, :permalink_format => :month # URL: http://example.com/faq/2011/01/test-faq
    faqmarkdown :as => :faq, :permalink_format => :year  # URL: http://example.com/faq/2011/test-faq
    faqmarkdown :as => :faq, :permalink_format => :slug  # URL: http://example.com/faq/test-faq

What about mapping Faqmarkdown to root? We got you covered:

    faqmarkdown :as => ''
    root :to => 'faqs#index'

## Example Directory Structure

    ├── app
    │   ├── controllers
    │   ├── helpers
    │   ├── mailers
    │   ├── models
    │   ├── faqs (where your markdown files live)
    │   │   ├── 2011-04-01-example-1.markdown
    │   │   ├── 2011-04-02-example-2.markdown
    │   │   ├── 2011-04-03-example-3.markdown
    │   │   ├── 2011-04-04-example-4.markdown
    │   └── views
    │       └── faqs (overridable)
    │           ├── _feed_link.html.haml
    │           ├── _faq.html.haml
    │           ├── feed.xml.builder
    │           ├── index.html.haml
    │           └── show.html.haml

## TODO

* Syntax highlighting for code blocks
* Generated routes should show example usage
* Support more file formats, eg. textile
* Built-in theme should have a link to the RSS Feed
* Generator tests

## Development

```
bundle
rake appraisal:install
rake # run the tests
```

## License

MIT License. Copyright 2011 Ennova.
