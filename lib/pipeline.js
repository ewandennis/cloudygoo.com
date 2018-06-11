const layouts = require('metalsmith-layouts');
const collections = require('metalsmith-collections');
const tags = require('metalsmith-tags');
const markdown = require('metalsmith-markdown');
const permalinks = require('metalsmith-permalinks');
const assets = require('metalsmith-assets');

const collectionSort = (a, b) => a.stats.birthtime < b.stats.birthtime;

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
      sortBy: 'created',
      reverse: true,
      refer: false
    }
  }))
  .use(markdown({
    gfm: true // Use GitHub-flavoured Markdown
  }))
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
  .use(assets({ source: './assets', destination: '.' }));
