fs = require 'fs'
cons = require 'consolidate'
marked = require 'marked'
_ = require 'lodash'

'use strict';

module.exports = (grunt) ->

  StyleGuide = require('styleguidejs')

  # override defaults from styleguidejs
  StyleGuide.defaultOptions =
    groupBy: "section"
    sortBy: [
      "section"
      "title"
    ]
    engine: "jade"
    extraJs: []
    extraCss: []
    outputFile: null
    template: __dirname + '/../node_modules/styleguidejs/lib/template/index.jade'
    templateCss: __dirname + '/../node_modules/styleguidejs/lib/template/styleguide.css'
    templateJs: __dirname + '/../node_modules/styleguidejs/lib/template/styleguide.js'


  # override render method from styleguidejs
  StyleGuide.prototype.render = (options, callback) ->

    options = @options = _.defaults(options or {}, StyleGuide.defaultOptions)

    # fetch the extra js files
    extraJs = []
    options.extraJs.forEach (file) ->
      extraJs.push readFileSync(file)
      return


    # append the extra stylesheets to the source
    options.extraCss.forEach ((file) ->
      @addFile file
      return
    ), this

    source = @parseSource()
    source = @parseHtmlIncludes(source)

    # data to send to the template
    data =
      marked: marked
      options: options
      docs: @groupSort(source)
      css: @sources.join(" ")
      js: extraJs.join("; ")
      templateCss: readFileSync(options.templateCss)
      templateJs: readFileSync(options.templateJs)

    if options.preprocess
      options.preprocess.call(grunt, data.docs);

    # template
    cons[options.engine] options.template, data, (err, html) ->

      if callback
        callback err, html
      if err
        throw err
      if options.outputFile
        fs.writeFileSync options.outputFile, html,
          encoding: "utf8"

      return

    return

  readFileSync = (file) ->
    fs.readFileSync file,
      encoding: "utf8"


  # ---
  # grunt task

  grunt.registerMultiTask 'styleguidejs', 'Generate nice styleguide', ->
    task = this
    options = @options {
      title: 'Styleguide'
      includejs: []
      customCSS: ''
      appendCustomCSS: []
    }

    # Iterate over all specified file groups.
    @files.forEach (f) ->

      # Concat specified files.
      src = f.src
        .filter (filepath) ->
          return grunt.file.exists(filepath) or grunt.file.isFile(filepath)

        .forEach (filepath) ->

          s = new StyleGuide()
          s.addFile(filepath)

          # render file
          s.render task.options({
            outputFile: f.dest
          })
