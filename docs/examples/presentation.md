# MOOSE Presentation Blaster 2.0

A tool to build a [reveal.js](http://lab.hakim.se/reveal-js/#/) slideshows using MOOSE flavored markdown.

---
# MOOSE Flavored Markdown

The presentation tool includes complete support for all special MOOSE markdown syntax.

--
## Alerts (Admonition)

!!! note
    All styles of MOOSE admonitions are available.

--
## Math
Math with [MathJax](https://www.mathjax.org/) and latex is fully supported.

$$\frac{\partial \phi}{\partial t} - \vec{v} \nabla \phi = 0$$

--

## Source Code
Complete source code and snippets are available.

!text test/tests/kernels/simple_diffusion/simple_diffusion.i start=Kernels end=Executioner

--
## Include Markdown
You can include other markdown files.

{!slides/presentation-include.md!}

---

# Slide Breaks

* Horizontal slides are separated with `---` alone on a line.
* Vertical slides are separated with `--` alone on a line, with the first slide showing on the horizontal progression.

---

# Slide Settings
<!-- .slide data-background="#00ff00" -->

The html for the slides can be modified using the following within an html comment.


`<!-- .slide data-background="#00ff00" -->`

--

## Internal Links
Slides are linked using title.

[Markdown](#moose-flavored-markdown)

    [Markdown](#moose-flavored-markdown)

Vertical slides are prefixed with the top-level name.

[Markdown Math](#moose-flavored-markdown-math)

    [Markdown Math](#moose-flavored-markdown-math)`

---
<!-- .slide data-background="#ff6700" -->

# Caution
The MOOSE presentation builder **does not** use the [reveal.js](http://lab.hakim.se/reveal-js/#/) markdown parsing, so do not attempt to use the syntax provided by the reveal.js system.

---
# Slide Generation Instructions

## (1) Clone reveal.js

```
cd ~/projects
git clone https://github.com/hakimel/reveal.js.git
```

--

## (2) Create Markdown

Generate a markdown file. The file should be located inside the
repository that you are working.

For example, this demo is generated from the 'demo.md' file located
in moose/docs/slides directory.

--

## (3) Generate Slides
MOOSE contains a python utility for converting the markdown that was created into
a presentation.

```
cd ~/projects/moose/docs
./moosedocs presentation /path/to/your/markdown.md
```

This will create an index.html file in your reveal.js checkout that contains the presentation. Run `./moosedocs presentation --help` for additional options when running this
script.

--

## (4) View Slides
To view the slides, simply open the index.html file created. On OSX you can preform the following.

```
open ~/projects/reveal.js/index.html
```
