const debug = require('metalsmith-debug');
const writemetadata = require('metalsmith-writemetadata');
const layouts = require('metalsmith-layouts');
const collections = require('metalsmith-collections');
const tags = require('metalsmith-tags');
const markdown = require('metalsmith-markdown');
const permalinks = require('metalsmith-permalinks');
const assets = require('metalsmith-assets');

module.exports = (metalSmith) =>
  metalSmith.metadata({
    siteTitle: 'Cloudy Goo',
    siteDescription: 'Creative coding and exploration through software',
    generator: 'Metalsmith',
    url: 'www.cloudygoo.com'
  })
  .source('./src')
  .destination('./build')
  .clean(true)
  .use(collections({
    article: {
      pattern: 'articles/*.md',
      sortBy: 'stats.ctime',
      refer: false
    }
  }))
  .use(markdown())
  .use(permalinks())
  .use(tags({
    handle: 'tags',
    metadataKey: 'tagList',
    path: 'tag/:tag.html',
    layout: 'tag.njk'
  }))
  .use(layouts({
    pattern: '**/*.html',
    engineOptions: {
      partials: 'partials',
      throwOnUndefined: true
    }
  }))
  .use(permalinks())
  .use(assets({ source: './assets', destination: '.' }))
  .use(debug())
  .use(writemetadata({
    pattern: ['**/*.html'],
    ignorekeys: ['contents'],
    bufferencoding: 'utf8'
  }));