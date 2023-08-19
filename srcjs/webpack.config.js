const path = require('path');

module.exports = {
  entry: './src/index.js',
  output: {
    library: 'rscatter',
    filename: 'bundle.js', // build with npx webpack
    path: path.resolve(__dirname, '..', 'inst', 'htmlwidgets', 'lib', 'rscatter'),
  },
};
