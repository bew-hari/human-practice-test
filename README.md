# Word Stem Frequency Analyzer

The Word Stem Frequency Analyzer is a web app that performs word stem frequency analysis on a user supplied text document. 


### Usage Notes

Most file formats supported under the Apache Tika toolkit (through the Yomu library). The [English (Porter2)](http://snowball.tartarus.org/algorithms/english/stemmer.html) stemmer algorithm will perform word stem extraction on the text data of the uploaded document, and the results will be displayed along with the original text.


### Technical

The Word Stem Frequency Analyzer relies on the following libraries/frameworks:

* [Ruby on Rails](http://rubyonrails.org/) - core MVC framework
* [Yomu](https://github.com/Erol/yomu) - a library for extracting text and metadata from documents
* [Twitter Bootstrap](http://getbootstrap.com/2.3.2/) - responsive UI framework for modern web apps


### Endnote

This web app is a small coding exercise as the first step in the Human Practice interview process.