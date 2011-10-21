# Omniturize
This gem integrates Omniture SiteCatalyst into your web app.

## Dependencies
This gem depends on [meta_vars](https://github.com/eLafo/meta_vars "eLafo's meta_vars") gem

## Installation
    gem install omniturize

## Based on and unaware collaborators
This is gem is based on [activenetwork's OmnitureClient gem](https://github.com/activenetwork/omniture_client "activenetwork's OmnitureClient"), which was forked from [acatighera's](https://github.com/acatighera/omniture_client, "acatighera's OmnitureClient").

There is some borrowed code from unawared coders. So thank you to

*   [acatighera](https://github.com/acatighera "acatighera github homepage")
*   [activenetwork](https://github.com/activenetwork "activenetwork github homepage")
*   [John Nunemaker](http://railstips.org/about "railstips") for his [ClassLevelInheritableAttributes solution](http://railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/ "Class and instance variables in ruby")

## Configuration
You must configure the Omniture namespace, suite(s), version that you wish to use.
Optionally, you can set up aliases to make things easier for yourself when coding reporters. Omniture uses c1, e1, r, etc to represent custom variables, e_vars, the referrer, etc. These param names are obscure and can be hard to remember so you can set up aliases for them.

    # config/omniture.yml
    development:
      base_url: http://102.112.2O7.net
      ssl_url: https://102.112.2O7.net
      suite: suite1
      version: G.4--NS
      aliases:
        search_term: c1
        movie_titles: e1
        referrer: r

Then, you should add this line to an initializer:

	Omniturize::config(YAML::load(File.open("#{Rails.root}/config/omniture.yml"))[Rails.env])

## Usage
###Attaching to the controllers
You can select which controllers you want to track by adding the next line

	class FooController < ApplicationController
		 omniturize
	end

For each controller you want to track, you should create a reporter. The root name of this reporter should be the same name as the controller -or the `BasicController` explained below.


	#FooReporter for FooController
	class FooReporter < Omniturize::Base
		...
	end

If there is a basic behaviour for some of your controllers, you should create a BasicReporter. This reporter will be used in case a reporter with the same name as the controller is not found.

	#BasicReporter
	class BasicReporter < Omniturize::Base
		...
	end


###vars
You can define a var by giving it a name and defining a block


	var :my_var do
		params[:id]
	end


You can define a var to be present only in given actions.

	#This var will be present only in index and new actions
	var :my_var,  'index', 'new' do
		'value_for_my_var'
	end


If no namespaces are passed, the defined var will be available in every action.

###Events
You can define an event the same way you define a var

	event :my_event, 'search' do
		'my_event'
	end

###Custom javascript
You can define custom javascript code the same way you define an event

	js_snippet :my_snippet 'search' do
		's.server = window.location.host;'
	end

###Using controller methods in the blocks
Since the block you are defining is executed within the controller context, you can use every method defined in your controller.

##File structure
My advice is to create these reporters in the 'app/reporters' directory, by creating this directory and adding it to the autoload_path

	config.autoload_paths += "#{RAILS_ROOT}/app/reporters"

You can create a hierarchy of reporters. This way you can share some configurations between classes and override them if necessary, e.g: you would want to create an ApplicationReporter which will contain the most common behaviour, and subclass this reporter for adding or modifying new vars, events, or js


	class ApplicationReporter < Omniturize::Base
		var :my_var do
			'common value'
		end
	end

	class FooReporter < ApplicationReporter
		var :my_var do
			'foo'
		end

		var :foo_var do
			'foo2'
		end
	end


## Views
Somewhere in your view -probably in one of your layouts- you should add the next line:


	@controller.reporter.js(:action => params[:action])


##More info
Since this gem has been created for a very specific use, it may be that this documentation is not enough for you. I have tried to keep the most code from the original sources, so you would want to take a look to the code itself or to the original sources where I took the code

* [OmnitureClient gem](https://github.com/acatighera/omniture_client "acathigera's OmnitureClient")
* [activenetwork's fork](https://github.com/activenetwork/omniture_client "activenetwork's OmnitureClient")
* [meta_vars gem](https://github.com/eLafo/meta_vars "eLafo's meta_vars")

##### Copyright (c) 2011 Javier Lafora, released under MIT license
