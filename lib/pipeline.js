const layouts = require('metalsmith-layouts');
const collections = require('metalsmith-collections');
const tags = require('metalsmith-tags');
const markdown = require('metalsmith-markdown');
const permalinks = require('metalsmith-permalinks');
const assets = require('metalsmith-assets');

const collectionSort = (a, b) => a.stats.birthtime < b.stats.birthtime;

module.exports = (metalSmith) =>
  // Site metadata headers
  metalSmith.metadata({
    siteTitle: 'Cloudy Goo',
    siteDescription: 'Creative coding and exploration through software',
    generator: 'Metalsmith',
    url: 'www.cloudygoo.com'
  })

  // Content is in ./src
  .source('./src')

  // Built output should go to ./build
  .destination('./build')

  // Clean old build output on each build
  .clean(true)

  // Read articles from articles/
  .use(
    collections({
      article: {
        pattern: 'articles/*.md',
        sortBy: 'created', // Sort them by file create date, in reverse order
        reverse: true,
        refer: false // Do not include nert and prev links in articles
      }
    }))

  // Convert *.md into HTML
  .use(
    markdown({
      gfm: true // Use GitHub-flavoured Markdown
    }))

  // Put each article into a directory named after the article
  .use(permalinks())

  // List articles by tag using the 'tags' property from each article header
  .use(
    tags({
      handle: 'tags',
      metadataKey: 'tagList',
      path: 'tag/:tag.html', // Put tag article list file under tag/
      layout: 'tag.njk'  // Use template to render tag list pages
    }))

  // Render content using pretty templates
  .use(
    layouts({
      pattern: '**/*.html', // Render content which matches this pattern
      engineOptions: {
        partials: 'partials', // The template bits are in layout/$partials
        throwOnUndefined: true
      }
    }))

  .use(permalinks()) // What, again?

  .use(
    assets({           // Non-content, like images, js, css etc are in ...
      source: './assets', // here
      destination: '.'    // put them here
    }));

