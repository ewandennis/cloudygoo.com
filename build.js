const Metalsmith = require('metalsmith');

const pipeline = require('./lib/pipeline');

const metalSmith = Metalsmith(__dirname);

pipeline(metalSmith).build(err => {
  if (err) {
    throw err;
  }
});
