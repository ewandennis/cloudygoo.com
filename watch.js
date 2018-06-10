const Metalsmith = require('metalsmith');
const serve = require('metalsmith-serve');
const watch = require('metalsmith-watch');

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

pipeline(metalSmith).build(err => {
  if (err) {
    throw err;
  }
});
