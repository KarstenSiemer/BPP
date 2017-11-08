# A thesis LaTeX-template

This LaTeX-template might be used to write a bachelor or master thesis at the computer science department at [h_da university of applied sciences](https://www.fbi.h-da.de/fbi.html "Hochschule Darmstadt, University of Applied Sciences") in Darstmadt. It is based on the fabulous ClassicThesis style template of [Andre Miedé](http://www.miede.de/ "Prof. Dr. Andre Miedé"). It is adapted to meet the current style guide for bachelor and master theses at the computer science department of h_da, as outlined in [Richtlinien zur Anfertigung der Bachelorarbeit](https://www.fbi.h-da.de/fileadmin/Inhalt/dokumente/Bachelor/BachelorProjekt/Richtlinien_Bachelorarbeit_070619.pdf)

## Configuration

The LaTeX template can be modified and configured easily using a very limited number of files, namely _classicthesis-config.tex_, _hdathesis-config.tex_, and _thesis.tex_. Only use these three files to modify your LaTeX thesis. Please _DO NOT_ modify the actual LaTeX code for your thesis (as this becomes quite complex and consumes a lot of time). 
Please finde a brief description of the various configuration options below:

### thesis.tex

The _thesis.tex_ file contains the basic structure all the chapter-files that contain the actual content of your thesis. Thus, you have to modify this file in order to incorporate your content files.

##### Two-sided vs. one-sided

The default output of the LaTeX thesis template a two-sided style that also has to be printet that way. In case you want to print one-sided only, you have to remove the _twoside_ option in the _\documentclass_ definition at line 35:

```
\documentclass[ openright,titlepage,numbers=noenddot,headinclude,%
                footinclude=true,cleardoublepage=empty,abstractoff,%
                BCOR=5mm,paper=a4,fontsize=11pt,
                ngerman,american,%
                ]{scrreprt}
``` 

You may also adapt the paper size (_paper=a4_) and the font size (_fontsize=11_) if necessary.

##### Bibliographies

By default all bibliographies that can be referenced in the thesis are put into the _bibliography.bib_ file in the root directory of the LaTeX sources. However, if you want to use additional bibliography files, you may add them to the bibliograph section (starting at line 47) in _thesis.tex_

```
%*************************************************************************
% Bibliographies
%*************************************************************************
\addbibresource{bibliography.bib}
.... ADD YOUR FILES HERE ...
```

##### Language

The default langauge of your thesis is German. If you want to switch to English, you have to modify the language selection from _ngerman_ to _american_ at line 63.

```
\selectlanguage{american} % ngerman, american
```

##### Table of content, figures, tables, listings, and acronyms

By default, the thesis templates prints a lot of table of content, i.e. for figures, tables, listings, and aconyms. You may want to remove such tables if you only have a very limited number, i.e. less then 3-5, of figures, tables, listings, and acronyms. Simply comment the related line in _thesis.tex_ starting at line 81.

```
%\cleardoublepage\include{frontbackmatter/Figures}
%\cleardoublepage\include{frontbackmatter/Tables}
%\cleardoublepage\include{frontbackmatter/Listings}
%\cleardoublepage\include{frontbackmatter/Acronyms}
```

##### Your content files

By default, the thesis template contains (includes) some default content files for chapters and appendix from the _./chapters/examples/_-directory (starting a line 94). You have to remove those includes and include your own files. Please note that it is best practice to put all your content in seperate files.

```
\cleardoublepage
\part{Thesis}\label{pt:thesis}
%\include{chapters/examples/chapter01}
%\include{chapters/examples/chapter02}
%\include{chapters/examples/chapter03}
... PUT YOUR INCLUDES FOR CHAPTERS HERE ...
%*************************************************************************
% Backmatter
%*************************************************************************
\appendix
%\renewcommand{\thechapter}{\alph{chapter}}
\cleardoublepage
\part{Appendix}
%\include{chapters/examples/appendix01}
%\include{chapters/examples/appendix02}
... PUT YOUR INCLUDES FOR APPENDIX HERE ...
```

You may also want to have a look at the _part(...)_ section at line 93 and 103. You may want to change the titles of the _part(...)_-sections. Alternatively, you remove the _part(...)_ section and the corresponding _cleardoublepage_ the line before.

### hdathesis-config.tex

### classicthesis-config.tex

### AbstractDE.tex and AbstractEN.tex

## Usage

The thesis template repository contains a Makefile that allows you to compile the thesis template using the _make_ t
ool available on most Unix and Linux systems. Simply type:

```
 $ make
```

to compile the LaTeX code into a PDF-file. Moreover, you may use

```
 $ make clean
```

to remove all temporary files, which are produced during the compilation process. Finally,

```
 $ make bz2
```

generates a bz2-package file, which contains all the source files of your LaTeX code.

## Known issues

* The LaTeX template only supports bachelor theses (by default)
* The thesis only supports German and (American) English

## License

The h_da computer science department LaTeX thesis template is licences under GPL v3.0