# Word Stem Frequency Analyzer

The Word Stem Frequency Analyzer is a web app that performs word stem frequency analysis on a user supplied text document. See http://wordfrequencyanalyzer.herokuapp.com/ for the live application.


### Overview

This web app:
 1. uses the built-in Ruby tempfile to handle user upload in conjunction with the [Yomu](https://github.com/Erol/yomu) library to read and save text content in a temporary local file,
 2. uses Ruby regular expressions to perform word stem extraction on the text data based on the [English (Porter2)](http://snowball.tartarus.org/algorithms/english/stemmer.html) stemmer algorithm and counts word frequencies, and
 3. displays the results along with the original user-supplied text.

Most file formats supported under the Apache Tika toolkit (through the Yomu library). Upload size is limited to 4 MB.

### Technical

The Word Stem Frequency Analyzer relies on the following libraries/frameworks:

* [Ruby on Rails](http://rubyonrails.org/) - core MVC framework
* [Yomu](https://github.com/Erol/yomu) - a library for extracting text and metadata from documents
* [Twitter Bootstrap](http://getbootstrap.com/2.3.2/) - responsive UI framework for modern web apps


### Endnote

This web app is a small coding exercise for the Human Practice interview process.