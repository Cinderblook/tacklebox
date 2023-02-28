### [Homer](https://github.com/bastienwirtz/homer)

#### Install using Git

If you are a git user, you can install the theme and keep up to date by cloning the repo:

    git clone https://github.com/dracula/homer.git

#### Install manually

Download using the [GitHub .zip download](https://github.com/dracula/homer/archive/master.zip) option and unzip them.

#### Activating theme

1. Copy ``custom.css`` to ``www/assets/custom.css``.
2. Copy ``dracula-background.png`` to ``www/assets/dracula-background``.
3. Put these lines into ``www/assets/config.yml`` and save the file:

```yml
# Will load Dracula theme.
stylesheet:
  - "assets/custom.css"
```

4. Refresh the page. Boom! It's working.
