# Documentation for Dingo Tiles

## Adding documentation pages

To allow new pages to be discovered they should be also added to the navigation sidebar for that section.

For example, for `dingo-s3` there is `docs-book/master_middleman/source/subnavs/_dingo_s3_subnav.erb`.

Add an HTML snippet into an appropriate place within the subnav:

```html
<li class="menu-link">
  <a href="/dingo-s3/new-page.html">New page of information</a>
</li>
```

## Deployment

There is a CI pipeline setup to automatically deploy any new changes to the documentation site.

* CI https://ci.vsphere.starkandwayne.com/pipelines/dingo-docs
* WWW/docs site https://www.dingotiles.com/ & https://docs.dingotiles.com/ currently same site

The docs application is deployed to Pivotal Web Services' organization `dingotiles`:

```
$ cf target

API endpoint:   https://api.run.pivotal.io (API version: 2.48.0)
User:           drnic@starkandwayne.com
Org:            dingotiles
Space:          docs-production
```

Email drnic@starkandwayne.com to request access to this organization & space.
