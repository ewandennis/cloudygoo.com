const Metalsmith = require('metalsmith');
const serve = require('metalsmith-serve');
const watch = require('metalsmith-watch');
const debug = require('metalsmith-debug');
const writemetadata = require('metalsmith-writemetadata');

const pipeline = require('./lib/pipeline');

const metalSmith = Metalsmith(__dirname);

metalSmith.use(watch({
  paths: {
    "${source}/**/*": true,
    "layouts/**/*": "**/*",
    "assets/**/*": "**/*"
  }
}))
.use(serve());

pipeline(metalSmith)
.use(debug())
.use(writemetadata({
  pattern: ['**/*.html'],
  ignorekeys: ['contents'],
  bufferencoding: 'utf8'
}))
.build(err => {
  if (err) {
    throw err;
  }
});
