const fs = require('fs')
const path = require('path')
const process = require('process')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const CleanWebpackPlugin = require('clean-webpack-plugin')
const MinifyPlugin = require('uglifyjs-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const webpack = require('webpack')

const env = process.env.NODE_ENV
const nameTemplate = env === 'production' ? '[name].[hash]' : '[name]'

let plugins = [
  new HtmlWebpackPlugin({
    template: './frontend/index.html'
  }),
  new webpack.DefinePlugin({
    API_URL: env === 'production' ? '"/api"' : JSON.stringify('http://localhost:3322/api'),
    'process.env.NODE_ENV': JSON.stringify(env)
  }),
  new webpack.optimize.CommonsChunkPlugin({
    name: 'vendor',
    minChunks: ({ context }) => (context && context.includes('node_modules'))
  })
]

let styleLoaders = [
  {
    loader: 'css-loader',
    options: {
      importLoaders: 1,
      sourceMap: true
    }
  }, {
    loader: 'postcss-loader',
    options: {
      plugins: function () {
        return [
          require('precss'),
          require('autoprefixer')
        ]
      },
      sourceMap: true
    }
  }, {
    loader: 'resolve-url-loader'
  }, {
    loader: 'sass-loader',
    options: {
      sourceMap: true
    }
  }
]

if (env === 'production') {
  plugins.push(
    new MinifyPlugin({
      test: /\.jsx?($|\?)/i
    }),
    new ExtractTextPlugin({
      filename: (getPath) => getPath(`/css/${nameTemplate}.css`).replace('css/js', 'css')
    }),
    new CleanWebpackPlugin(['public'])
  )
  styleLoaders = ExtractTextPlugin.extract({
    fallback: 'style-loader',
    use: styleLoaders
  })
} else {
  plugins.push(new webpack.HotModuleReplacementPlugin())
  styleLoaders.unshift({ loader: 'style-loader' })
}

const packageJSON = require(path.resolve(__dirname, 'package.json'))
const deps = Object.keys(packageJSON.dependencies)

const config = {
  entry: {
    vendor: deps.filter(module => module !== 'bootstrap-sass'),
    app: './frontend/index.jsx'
  },
  output: {
    path: path.resolve(__dirname, 'public'),
    filename: `js/${nameTemplate}.js`
  },
  module: {
    rules: [
      {
        test: /\.js.env$/
      },
      {
        test: /\.jsx?$/,
        include: [
          path.resolve(__dirname, 'frontend')
        ],
        loader: 'babel-loader',
        options: {
          presets: ['es2015', 'react'],
          plugins: ['transform-object-rest-spread'],
          sourceMap: true
        }
      },
      {
        test: /\.html$/,
        loader: 'html-loader'
      },
      {
        test: /\.scss$/,
        use: styleLoaders
      }, {
        test: /\.(eot|svg|ttf|woff|woff2)(\?.*)?$/,
        loader: 'file-loader',
        options: {
          name: `fonts/${nameTemplate}.[ext]`
        }
      }
    ]
  },
  resolve: {
    modules: [
      'node_modules',
      path.resolve(__dirname, 'frontend')
    ],
    extensions: ['.js', '.json', '.jsx', '.css']
  },
  target: 'web',
  node: {
    fs: 'empty'
  },
  plugins: plugins
}

if (env === 'production') {
} else {
  config.devServer = {
    contentBase: path.join(__dirname, 'public'),
    compress: true,
    historyApiFallback: true,
    hot: true
  }
  config.devtool = 'inline-source-map'
}

module.exports = config
