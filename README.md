# Underskeleton Downloader

Download API for [Underskeleton Starter Theme](http://github.com/diegoversiani/underskeleton) Project for WordPress.

You may want to visit [getunderskeleton.com/download](http://getunderskeleton.com/download) to create your copy of Underskeleton.

The API provides an easy way to create copies of Underskeleton and change its identification as Underskeleton is intended to be a starter theme and not a parent theme for WordPress.

It clones the **last released tag** of the Underskeleton Project and create the new theme based on it.

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

Example:

```
# Will create a theme name New Theme Name and slug 
https://underskeleton-downloader.herokuapp.com/themes/create?name=New%20Theme%20Name&slug=new_theme_name
```

If `slug` is not provided the API will convert the name into slug

Example:

```
# Will create a theme name 'New Theme Name' and slug 'new_theme_name'
https://underskeleton-downloader.herokuapp.com/themes/create?name=New%20Theme%20Name
```
