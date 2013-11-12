# planet.webcompat.com

This repository holds the code that powers http://planet.webcompat.com, a "Planet" aggregator of blogs and feeds that relate to web compatibility.

## Building

`git clone git@github.com:miketaylr/planet.webcompat.com.git`
`cd planet.webcompat.com`
`git submodule init && git submodule update`
`python venus/planet.py config.ini`*

The generated assets will be in `output/`.

*You may need to grab some of Venus's depedencies depending on your setup.

## Contributing

If you'd like to add your blog or feed for a "webcompat" tag (or similar), send a pull request updating the config.ini in the appropriate place.

Pull requests are also welcome for other aspects of the site, e.g., theme improvements.
