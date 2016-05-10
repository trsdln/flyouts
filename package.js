Package.describe({
  name: 'trsdln:flyouts',
  version: '1.1.3',
  // Brief, one-line summary of the package.
  summary: 'Easy customizable and reactive sidebar flyouts',
  // URL to the Git repository containing the source code for this package.
  git: 'https://github.com/trsdln/flyouts',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function (api) {
  api.versionsFrom('1.2');
  api.use([
    'mongo',
    'templating',
    'blaze',
    'jquery',
    'underscore',
    'less'
  ], 'client');


  api.addFiles([
    'flyout-manager/flyout-manager.html',
    'flyout-manager/flyout-manager.js',
    'flyout-manager/flyout/flyout.html',
    'flyout-manager/flyout/flyout.js',
    'flyout-manager/flyout-manager.less'
  ], 'client');

  //api.export('FlyoutManager', 'client');
});
