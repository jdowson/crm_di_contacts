crm_di_contacts
===============

Overview
--------

For the moment this plugin simply acts as a test harness for the [crm_di_core][4] plugin for [Fat Free CRM][2], adding a contact type and subtype to the *contact* model, using the *lookup* functionality in the core module.

This demonstrates the use of the *lookup* admin functionality to maintain cascading dropdown list values, integration of the lookup cache to reduce round trips to the database and the ease with which interacting controls can be added to forms using Fat Free view hooks.

The final target version will add further functionality to allow more flexible contact (and account) associations:


* Multiple associations between contacts, accounts and other models. For example, allowing several contacts, potentially associated with different accounts to be linked to an opportunity with specific roles such as 'influencer', 'decision maker', 'implementation partner'. 
* Allowing these links to extend the list of related opportunities/leads etc. displayed for each contact/account.
* Allowing these relationships to be n-tier, for example allowing 'head office', 'regional office', 'branch' relationships to be maintained for accounts, with the ability to roll-up data such as opportunities for higher tiers while storing the opportunity at the lowest tier.


Installation
------------

From the root of your Fat Free CRM installation run:

> `./script/plugin install [source]`

Where [source] can be, according to your needs, one of:

> SSH:
>    `git@github.com:jdowson/crm_di_contacts.git`
>
> Git: 
>    `git://github.com/jdowson/crm_di_contacts.git`
>
> HTTP:
>    `https://jdowson@github.com/jdowson/crm_di_contacts.git`

The database migrations required for the plug can be installed with the following command:

> `rake db:migrate:plugin NAME=crm_di_contacts`

...that can be run from the Fat Free CRM installation root.


Sample Data
-----------

Sample *contact type* and *contact subtype* lookup fields may be created using the following *rake* command:

> `rake crm:di:contacts:setup`

These fields initially contain no lookup values. Sample values can be installed with the following *rake* command:

> `rake crm:di:contacts:demo`

These commands respond to the usual rake environment options, such as `RAILS_ENV=test`.


Tests
-----

See the *readme* for the [crm_di_core][4] repository for general comments on tests.


Copyright (c) 2010 [Delta Indigo Ltd.][1], released under the MIT license

[1]: http://www.deltindigo.com/                 "Delta Indigo"
[2]: http://www.fatfreecrm.com/                 "Fat Free CRM"
[3]: http://www.github.com/                     "github"
[4]: https://github.com/jdowson/crm_di_core     "crm_di_core"

