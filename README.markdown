crm_di_core
===========

Overview
--------

Experimental plugin module for Fat Free CRM, with the initial target of:

* Exploring a range of integration points for plugin functionality to Fat Free CRM
* As an example, providing end user (administrator) functionality to manage drop down list values that can then be used in extensions to Fat Free CRM entities as well as a wholey new models that can be integrated with the core product.
* Erm...working out how all this rails stuff hangs together anyway.


Installation
------------

From the root of your Fat Free CRM installation run:

>`./script/plugin install [source]`

Where [source] can be, according to your needs, one of:

>  SSH:
>    `git@github.com:jdowson/crm_di_core.git`
>
>  Git: 
>    `git://github.com/jdowson/crm_di_core.git`
>
>  HTTP:
>    `https://jdowson@github.com/jdowson/crm_di_core.git`

The database migration is currently under development, however the plugin does create a rake task:

>  `rake db:migrate:di_core`

...that can be run from the Fat Free CRM installation root.

This will install the required database changes against a 'vanilla' Fat Free CRM database but cannot be guaranteed to (and almost certainly won't!) 'play nicely' at this time with any future Fat Free CRM database migrations, future versions of this plugin, any other plugins. If in doubt, the individual migrations can be inspected in `vendor/plugins/crm_di_core/db/migrate` and used to implement the required changes in a manner with your own database mangagement strategy.


Tests
-----

*rspec* tests in the `spec` directory are not currently pushed to [github][2] as, for the time being they are **much** more buggy than the code they are intended to test, so the *develop_test_scripts* branch is staying local for now!


Copyright (c) 2010 [Delta Indigo Ltd.][1], released under the MIT license

[1]: http://www.deltindigo.com/             "Delta Indigo"
[2]: http://www.github.com/                 "github"
