const path = require('path')

module.exports = {
  stories: [
    "../app/javascript/**/*.stories.mdx",
    "../app/javascript/**/*.stories.@(js|jsx|ts|tsx)"
  ],

  addons: [
    "@storybook/addon-links",
    "@storybook/addon-essentials"
  ],

  typescript: {
    reactDocgen: 'react-docgen-typescript',
    reactDocgenTypescriptOptions: {
      // includes third-party imported typescript react props by default (see propFilter below)
      compilerOptions: {
        allowSyntheticDefaultImports: false,
        esModuleInterop: false,
      },
      propFilter: (prop) => {
        // we want to include all the styled-system props for reference...
        if (prop.parent && /styled-system/.test(prop.parent.fileName))
          return true
        // ...and exclude all the other third-party libraries
        return (prop.parent ? !/node_modules/.test(prop.parent.fileName) : true)
      },
    }
  },

  webpackFinal: async (config) => {
    config.resolve.modules = [
      ...(config.resolve.modules || []),
      path.resolve(__dirname, "../app/javascript"),
    ]

    return config;
  }
}
