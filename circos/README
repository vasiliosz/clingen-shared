Circos templates and scripts for different genomic sources
----------------------------------------------------------

## Install Circos on OSX
Use [Homebrew](http://brew.sh) to install necessary Perl modules easier.

```
brew tap homebrew/science
brew remove gd
brew install gd --with-freetype
brew install cpanminus
sudo chown "$USER":admin /Library/Perl/5.16 # on Mac OS
sudo cpanm Config::General Font::TTF::Font Math::Bezier Math::VecStat Readonly Set::IntSpan Text::Format Statistics::Basic SVG
sudo cpanm --force GD::Polyline
```

And link the Perl env [per Circos manual](circos.ca/software/readme)
```
sudo sh
cd /bin
ln -s /usr/bin/env /env
```

Export the `/path/to/circos/bin` to your `$PATH`

***

To run example templates

```
cd circos-template
# Will run with circos.conf by default
circos
# Run with different configuration file
circos -conf etc/circos-annotated-fusion_only.conf
```
