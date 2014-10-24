# Grunt plugin for [Styleguide.js](https://github.com/EightMedia/styleguide.js)

Generate a styleguide from your CSS, by adding [YAML](http://en.wikipedia.org/wiki/YAML) data in the comments.
It generates a [self-contained html](https://rawgithub.com/EightMedia/styleguide.js/master/test/expected/index.html) file. Works great for component based CSS.

![Screenshot](https://rawgithub.com/EightMedia/styleguide.js/master/screenshot.png)

### How to use
Add this to your projects gruntfile.

```coffeescript

grunt.loadNpmTasks('grunt-styleguidejs')

grunt.initConfig
  styleguidejs:
    default:
      files: {
        'styleguide/index.html': ['css/all.css']
      }
```

or with custom options:
``` coffeescript
grunt.initConfig
  styleguidejs:
    custom_options:
      options: {
        title: 'Custom Styleguide'
        extraJs: ['modernizr.js','jquery.js']
        extraCss: 'test/fixtures/custom-css/style.css'
        template: 'styleguide/styleguide.jade',
        preprocess: function(sections) {
          for (var i = 0; i < sections.length; i++) {
            sections[i].title += " (" + sections[i].guides.length + ")";
          }
        }
      }
      files: {
        'styleguide/index.html': ['css/all.css']
      }
```

then in your `css/all.css`:

````css
body {
  font: 16px Verdana;
}

/***
  title: Square buttons
  section: Buttons
  description: Very pretty square buttons
  example: |
    <a href="" class="btn btn-small">button</a>
    <a href="" class="btn btn-medium">button</a>
    <a href="" class="btn btn-large">button</a>
***/

.btn{
  display: inline-block;
  padding: .3em .6em;
  color: white;
  text-decoration: none;
  text-transform: uppercase;
  background-color: darkslateblue;
}
.btn:hover{
  background-color: #38306E;
}
.btn-small{
  font-size: .8em;
}
.btn-medium{
  font-size: 1em;
}
.btn-large{
  font-size: 1.3em;
}


/***
  title: Round buttons
  section: Buttons
  description: Very pretty rounded buttons
  example: |
    <a href="" class="btn btn-small btn-round">button</a>
    <a href="" class="btn btn-medium btn-round">button</a>
    <a href="" class="btn btn-large btn-round">button</a>
***/

.btn-round{
  border-radius: 20px;
}


/***
  title: Links
  section: Buttons
  id: btn-link
  description: Very pretty rounded buttons
  example:
    <a href="" class="btn-link">button</a>
***/

.btn-link{
  background: none;
  color: darkslateblue;
}
.btn-link:hover{
  text-decoration: none;
}

/***
  title: Includes
  section: Includes
  description: Include example code from other items. You can refer to any attribute(set), like 'id'
  example: |
    <div class="btn-group">
        <include title="Links" section="Buttons">
        <include title="Links" section="Buttons">
        <include id="btn-link">
    </div>
***/
.btn-group .btn-link {
    background: green;
}
````


For more info see [https://github.com/EightMedia/styleguide.js/](https://github.com/EightMedia/styleguide.js/)
