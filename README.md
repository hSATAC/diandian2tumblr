# Diandian to Tumblr

This tool import yout diandian backup xml into tumblr.

## Usage

1. Get your diandian backup xml from [diandian.com](http://diandian.com) and rename it to `diandian.xml`.

1. [Register a tumblr application](https://www.tumblr.com/oauth/apps) and get your consumer key & secret.

1. Run `cd oauth && bundle install && bundle exec generate-token`, follow the instructions to get your oauth token & secret.

1. Run `bundle install`, copy `settings.yml.example` to `settings.yml` and fill those keys.

1. Run `ruby import.rb`

Now your blog should be imported.

## Notice

1. Diandian exported xml does not contain photo info, so I use a fake image instead.

2. I only implemented `text`, `photo` and `link`. If you need other post type, pull requests are welcomed.
