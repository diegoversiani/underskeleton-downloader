# Underskeleton Downloader

Download API for [Underskeleton Starter Theme](http://github.com/diegoversiani/underskeleton) Project for WordPress.

You may want to visit [getunderskeleton.com/download](http://getunderskeleton.com/download) to create your copy of Underskeleton.

The API provides an easy way to create copies of Underskeleton and change its identification as Underskeleton is intended to be a starter theme and not a parent theme for WordPress.

It clones the **last released tag** of the Underskeleton Project and create the new theme based on it.

**> > Now you can specify a branch name to create your copy from. See below.**

## Usage

The API is hosted at https://underskeleton-downloader.herokuapp.com

#### Endpoints

There is only one endpoint available: `/themes/create`

Simply send a `get` request to `https://underskeleton-downloader.herokuapp.com/themes/create` and pass in the parameters:

- name (required)
- slug 
- author (optional)
- author_uri (optional)
- description (optional)
- branch (optional)

###### Default usage

Copy from last stable release, providing name and slug.

```
# Will create a theme name 'New Theme Name' and slug 'theme_slug'
https://underskeleton-downloader.herokuapp.com/themes/create?name=New%20Theme%20Name&slug=theme_slug
```


###### Name converted into slug

If `slug` is not provided the API will convert the name into slug

```
# Will create a theme name 'New Theme Name' and slug 'new_theme_name'
https://underskeleton-downloader.herokuapp.com/themes/create?name=New%20Theme%20Name
```


###### Copy from specific branch

Provide a value to `branch` parameter to copy from it.

If you want to copy from `master` branch, for example:

```
# Will create a theme name 'New Theme Name' and slug 'theme_slug' from MASTER branch
https://underskeleton-downloader.herokuapp.com/themes/create?name=New%20Theme%20Name&slug=theme_slug&branch=master
```
