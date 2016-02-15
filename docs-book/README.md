# DingoDB Product Documentation

This project publishes the DingoDB Product Documentation as a web application.

**Breaking Change**: This book now uses a centralized layout repository, [docs-layout-repo](https://github.com/pivotal-cf/docs-layout-repo).  
You must clone this repository to run `bookbinder bind local`.

The centralized layout repository is specified as the value of the `layout_repo` key in the `config.yml` file.
Bookbinder uses this centralized layout repository by default, but files in the book's `master_middleman/source` directory override files in the centralized layout repository if they have the same name.

## What's in this Repo

This repo uses the [Bookbinder gem](http://github.com/pivotal-cf/docs-bookbinder) to generate the documentation as a web application.

The `config.yml` file contains the list of topic repositories.

The `master_middleman` folder contains the template used for publishing

This repository does not contain the documentation content. That's contained in the topic repositories listed in the `config.yml`.

## Topic Repositories

The topic repositories that make up the DingoDB documentation set are:

* [AWS S3](http://github.com/dingodb/docs-amazon-s3): AWS S3 buckets for Cloud Foundry

## Contributing Pull Requests

To submit a pull request to the documentation, please follow this process:

1. Make sure you have a signed CLA. Even if you aren't contributing running code, we still need a Contributor License Agreement.

2. Clone this repository. (You do not need to fork this repository unless you plan to contribute template changes or add a new topic repository).

3. Fork the topic repository that you want to contribute to. Make sure to clone your fork of the topic repository to a directory that is a sibling to this book repository. So, for example, if you are contributing content to the Buildpack documentation, your folder structure would look like this:

  <pre>

    |
    +-- docs-book-cloudfoundry
    |
    +-- docs-buildpacks
    |
  </pre>

4. Make your changes.

5. This book now uses a centralized layout repository. Clone the [docs-layout-repo](https://github.com/pivotal-cf/docs-layout-repo) for bookbinder `bind` to run properly.

6. Run & preview your changes by running the resulting Sinatra app:

  <pre>
    $ cd docs-book-cloudfoundry
    $ bundle install --binstubs
    $ ./run.sh
  </pre>

The `run.sh` serves the documentation at http://localhost:4567/

Bookbinder attempts to assemble the doc set from your local copies.
It will skip any topic repositories that you do not have checked out.

Note that Bookbinder will tell you if you have any broken links.
It might report broken links associated with topic repositories that you
do not have on your local machine.

When you are satisfied with your changes, submit your pull request on
the topic repository.
