# My website repo

This is my [github page](https://joachimburket.github.io) repository. I'm using it to store some tips on experiences I had.

The repository is forked from [kitian616/jekyll-TeXt-theme](https://github.com/kitian616/jekyll-TeXt-theme), which is the used theme.

## Structure

Here is the structure of the important folders and files in this repository:

```bash
.
├── assets/                 # CSS and images
├── _cheatsheets            # programming languages cheatsheets
├── _data                   # YAML data
├── docker                  # docker files to build and run the website
├── _includes               # HTML includes (extensions, search, analytics, comments, sharing, etc..)
├── _layouts                # pages layouts
├── posts                   # conains all the Posts of the blog, separated in subfolders (themes)
├── _sass                   # contains the styles and animations (components, themes, code highlights)
├── tools
├── 404.html
├── about.md                # about page
├── archive.html
├── cheatsheets.md          # cheatsheets page
├── _config.yml             # jekyll config file
├── Dockerfile              # image to build and run jekyll
├── favicon.ico
├── Gemfile
├── index.html
├── jekyll-text-theme.gemspec
├── package.json
└── serve.sh
```

## Build and run locally

The website is built using [jekyll](https://jekyllrb.com/). See https://jekyllrb.com/docs/installation/ to install the tools needed to build the site.

To locally build and serve it, run the `serve.sh` script. 

```bash
./serve.sh
```

## Build and run using the Dockerfile

It is also possible to build and run the blog using a Docker container. From the root of the repo, run these commands:

```bash
# Build the image
$ podman-compose -f docker/docker-compose.build-image.yml build

# Run the blog
$ podman-compose -f docker/docker-compose.serve.yml up
```

To stop the website, open another terminal and run:

```bash
$ podman-compose -f docker/docker-compose.serve.yml down
```
