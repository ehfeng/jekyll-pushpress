# PushPress
> Subscribe, Schedule, and Search for Jekyll

## Publishing the gem

1. Build the gem

`bundle exec gem build jekyll-pushpress.gemspec`

2. Push the gem

`bundle exec gem push jekyll-pushpress-0.0.1.gem`

## Steps

1. `git clone --depth 1 repo`

2. Replace Gemfile

```
source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
gem 'jekyll-pushpress'
```

3. Add pushpress_config.yml

`gems: ["jekyll-pushpress"]`

3. Insert `pushpress` directory in `_layouts`, with default newsletter template.

Sends to PushPress server
- front matter fields
- hash of page or document content.
- if subscribe is enabled, use or add templates to `_layouts/pushpress` directory
	- `letter.html`
	- `subscribe.html` (webview)
	- `unsubscribe.html` (webview)

4. Run...

`DISABLE_WHITELIST=true bundle exec jekyll build --config=_config.yml,pushpress_config.yml --destination=/dev/null`

## Sample

`cd sample`

`bundle install`

`PAGES_REPO_NWO=ehfeng/jekyll-pushpress DISABLE_WHITELIST=true bundle exec jekyll serve --config=_config.yml,pushpress_config.yml`
