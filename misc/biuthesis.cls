%%
%% biuthesis
%%
%% A class for authoring graduate degree theses
%% according to the specifications of the Technion -
%% Israeli Institute of Technology
%%
%% GitHub repository:
%% https://github.com/eyalroz/technion-iit-thesis/
%%
%%
%% Maintainer:
%% Eyal Rozenberg       <eyalroz@technion.ac.il>
%%                      <eyalroz@riseup.net>
%%
%% Original author:
%% Dan Kenigsberg       <danken@cs.technion.ac.il>
%%
%% Contributor:
%% Ido Tal              <idotal@ee.technion.ac.il>
%%
%%

\def\filename{biuthesis}
\def\fileversion{v0.9}
\def\filedate{2017/09/18}
\NeedsTeXFormat{LaTeX2e}
\edef\biuthesis@BarIlanBIUThesis{%
\filedate\space\fileversion\space - Bar-Ilan BIU Thesis}
\ProvidesClass{\filename}[\biuthesis@BarIlanBIUThesis]

%--------------------------------

% Packages and package option setting - before option processing

\RequirePackage{etoolbox}

%--------------------------------

% The different degrees the Technion awards for which you might
% be writing a thesis. At the moment, the author(s) are not aware of
% any difference in the style requirements for theses for
% different degrees

% A Ph.D. thesis is the default...
\newcommand{\biuthesis@degreeEnglish}{Doctor of Philosophy}
\newcommand{\biuthesis@degreeHebrew}{דוקטור לפילוסופיה}
\DeclareOption{PhD}{%
}

\DeclareOption{MSc}{%
  \renewcommand{\biuthesis@degreeEnglish}{Master of Science in \biuthesis@disciplineEnglish}
  \renewcommand{\biuthesis@degreeHebrew}{מגיסטר למדעים ב\relax\biuthesis@disciplineHebrew}
}

\DeclareOption{MArch}{%
  \renewcommand{\biuthesis@degreeEnglish}{Master of Architecture}
  \renewcommand{\biuthesis@degreeHebrew}{מגיסטר לארכיטקטורה}
}

\DeclareOption{MEcon}{%
  \renewcommand{\biuthesis@degreeEnglish}{Master of Economics}
  \renewcommand{\biuthesis@degreeHebrew}{מגיסטר לכלכלה}
}

\DeclareOption{ME}{%
  \renewcommand{\biuthesis@degreeEnglish}{Master of Engineering}
  \renewcommand{\biuthesis@degreeHebrew}{מגיסטר להנדסה}
}

\newbool{biuthesis-abbrevs}
\booltrue{biuthesis-abbrevs}
\DeclareOption{noabbrevs}{
  % No abbreviations & notiation section
  \boolfalse{biuthesis-abbrevs}
}

\newbool{biuthesis-includeack}
\booltrue{biuthesis-includeack}
\DeclareOption{beforeDefense}{
  % No personal Acknowledgement are printed before the thesis is successfully
  % defended (this is also known, especially in Hebrew, as taking an "exam on
  % your thesis")
  \boolfalse{biuthesis-includeack}
}

\newcommand{\biuthesis@geometry}{%
  \geometry{a4paper,nohead,twoside,top=2.5cm,bindingoffset=1.5cm,hmargin=2.5cm}}
\DeclareOption{fullpageDraft}{
 \newcommand{\biuthesis@fullpageDraft}{}
 \renewcommand{\biuthesis@geometry}{%
   \geometry{a4paper,nohead,twoside,bindingoffset=0cm,vmargin=2.5cm,hmargin=2.5cm}}
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

\ProcessOptions\relax

\LoadClass[a4paper,11pt,twoside,openright]{report}

%--------------------------------

% Packages and package option setting - after option processing

% The following package  is required for fixing a Hebrew bulleted list issue, see
% https://tex.stackexchange.com/questions/53444/
\RequirePackage{enumitem}
\RequirePackage{fontspec}
\RequirePackage{geometry} % Note: must be loaded before bidi
\RequirePackage{setspace}
\RequirePackage{atbegshi}

\biuthesis@geometry

%--------------------------------

% Polyglossia & language settings

% Note: We're not indicating the use of Hebrew right away, because the 
% bidi package, which polyglossia loads for Hebrew text, is very picky 
% about when it can be loaded. It must be loaded _after_ packages such as
% graphics, amsmath, float, ntheorem and others; and since we're not 
% going to load all of these right away (in fact, we might not be loading 
% them at all - it's up to the document author whether s/he needs them or 
% not) we want to defer loading and using polyglossia until after the 
% document author has loaded whatever it is they intend to use

\RequirePackage{polyglossia}
\setmainlanguage{english} % Palestine was under British rule after all
\IfFileExists{bidi.sty}{}{\ClassError{\filename}{The bidi package is not available for loading}{}}
\AtEndPreamble{
 \setotherlanguage[numerals=arabic,calendar=gregorian]{hebrew}
 \newfontfamily\hebrewfont[Script=Hebrew]{Times New Roman}
 % These next two lines fix an issue with equation numbering parentheses;
 % see: https://tex.stackexchange.com/a/141437/5640
 \def\maketag@@@#1{\hbox{\m@th\normalfont\LRE{#1}}}
 \def\tagform@#1{\maketag@@@{(\ignorespaces#1\unskip)}}
}

%--------------------------------

%\doublespacing
\onehalfspacing

%--------------------------------


% A mechanism for determining whether the document contained
% any figures. Using this, we can decide whether or not we need
% a list of figures
% see: http://tex.stackexchange.com/q/33193/5640
%

\AtEndEnvironment{figure}{\gdef\biuthesis@havefigures{}}
% The following fails for some reason... moving it to the
% makebackmatter command
%\AtEndDocument{
% \ifdefined\biuthesis@havefigures
%  \label{biuthesis:had-figures}
% \fi
%}
\newcommand{\conditionallistoffigures}{
 \@ifundefined{r@biuthesis:had-figures}
 {}
 {%
  \listoffigures%
  \addcontentsline{cot}{chapter}{רשימת איורים}%
  \addcontentsline{toc}{chapter}{List of Figures}%
  }
}%

%--------------------------------

% Commands regarding the typesetting of the Hebrew material
% at the end of the thesis

% This commands flips the inner and outer margins; the motivation is
% that for Hebrew content, the binding is on the right side of the first
% page on the sheet, and on the left side of the second page on the sheet
% (not sure if I can call them recto and verso in this situation)
% see: http://tex.stackexchange.com/q/33193/5640
%
% The link also has code for when you have 'headings' page styles, which in
% general Technion theses should not

\newcommand*{\flipmargins}{%
  \clearpage
  \setlength{\@tempdima}{\oddsidemargin}%
  \setlength{\oddsidemargin}{\evensidemargin}%
  \setlength{\evensidemargin}{\@tempdima}%
  \if@reversemargin
    \normalmarginpar
  \else
    \reversemarginpar
  \fi
}

% see http://tex.stackexchange.com/q/21703/5640

\newif\ifRP%
\newbox\RPbox%
\setbox\RPbox\vbox{\vskip1pt}%
\AtBeginShipout{%
  \ifRP
    \AtBeginShipoutDiscard%
    \global\setbox\RPbox\vbox{\unvbox\RPbox
      \box\AtBeginShipoutBox\kern\c@page sp}%
  \fi
}%
\renewcommand{\RPtrue}{%
  \clearpage
  \ifRP\RPfalse\fi
  \global\let\ifRP\iftrue
}%
\let\reversepageorder=\RPtrue%
\renewcommand{\RPfalse}{%
  \clearpage
  \global\let\ifRP\iffalse
  \setbox\RPbox\vbox{\unvbox\RPbox
    \def\protect{\noexpand\protect\noexpand}%
    \@whilesw\ifdim0pt=\lastskip\fi
      {\c@page\lastkern\unkern\shipout\lastbox}%
  }%
}%
\let\resumenormalpageorder=\RPfalse%

%--------------------------------

% All the various data fields which the user must/should set, with
% generic/placeholder defaults
%
% for every thesis field, say titleEnglish, the class user (that means you
% who are writing your thesis) must invoke
% \titleEnglish{Non-linear Hummus Optimization}
% to replace the default;  every field has its own command, e.g. for the  name
% of your discipline in Hebrew you would use
% \disciplineHebrew{Bio-technical Engineering}
%
% Note that _all_ fields defined below are necessary, at the moment,
% to meet the Technion's thesis submission guidelines
%

%
\newcommand{\biuthesis@thesisdatafield}[2]{%
  % this defines the internal command which stores the field value
  \@namedef{biuthesis@#1}{#2}
  % this defines the command with which the class user will set the value
  \long\@namedef{#1}##1{\@namedef{biuthesis@#1}{##1}}
}

\biuthesis@thesisdatafield{authorEnglish}{Name of Author}
\biuthesis@thesisdatafield{authorHebrew}{שם המחבר}
\biuthesis@thesisdatafield{titleEnglish}{Thesis Title}
\biuthesis@thesisdatafield{titleHebrew}{כותרת החיבור}
\biuthesis@thesisdatafield{disciplineEnglish}{Discipline Name}
\biuthesis@thesisdatafield{disciplineHebrew}{שם התחום המדעי}
\biuthesis@thesisdatafield{supervisionEnglish}{Information regarding the supervision and supervisors}
\biuthesis@thesisdatafield{supervisionHebrew}{מידע על המנחים וההנחיה}
\biuthesis@thesisdatafield{publicationInfoHebrew}{ציון אם העבודה פורסמה בכתבי עת או  הוצגה בכנסים. הרשימה תכתב בהתאם לכללי הציטוט (כולל הכותר ושמות השותפים). במקרה של שיתוף פעולה, פירוט תרומת המגיש.}
\biuthesis@thesisdatafield{publicationInfoEnglish}{Info about whether the contents of the thesis was published, about collaborators and the thesis author's contribution.}
\biuthesis@thesisdatafield{GregorianDateEnglish}{Gregorian Month and Year}
\biuthesis@thesisdatafield{GregorianDateHebrew}{חודש ושנה גרגוריאניים}
\biuthesis@thesisdatafield{JewishDateEnglish}{Hebrew Month and Year}
\biuthesis@thesisdatafield{JewishDateHebrew}{חודש ושנה עבריים}
\biuthesis@thesisdatafield{personalAcknowledgementEnglish}{The author's personal acknowledgements.}
\biuthesis@thesisdatafield{personalAcknowledgementHebrew}{שלמי-התודה של המחבר.}
\biuthesis@thesisdatafield{financialAcknowledgementEnglish}{The generous financial help of Bar-Ilan University is gratefully acknowledged.}
\biuthesis@thesisdatafield{financialAcknowledgementHebrew}{אני מודה לאוניברסיטת בר-אילן על התמיכה הכספית הנדיבה בהשתלמותי.}
% Regulations require the English abstract contain 200-500 words.
\biuthesis@thesisdatafield{abstractEnglish}{Abstract of the thesis.}
% Regulations require the Hebrew abstract contain 1,000-2,000 words.
\biuthesis@thesisdatafield{abstractHebrew}{תקציר החיבור.}
\biuthesis@thesisdatafield{abbreviationsAndNotation}{Abbreviations and notations listing here.} 
\biuthesis@thesisdatafield{thesisbibstyle}{alpha}
% the following should be a comma-separate list of relative filenames,
% e.g. {backmatter/compsci.bib,backmatter/math.bib,specific.bib}
\biuthesis@thesisdatafield{thesisbibfiles}{}

%--------------------------------

% These next two commands are for the class user to invoke:


\newcommand{\makefrontmatter}{%
 \makeatletter
 \hypersetup{pdftitle={\biuthesis@titleEnglish},pdfauthor={\biuthesis@authorEnglish}}
 \makeatother

 \pagestyle{empty}

%  \makecoverEnglish
%  \cleardoublepage
 \maketitleEnglish
 \cleardoublepage
 \makeacknowledgementsEnglish
 \cleardoublepage

 % Workaround: The first page of the table of contents is getting numbered,
 % although it's not supposed to be (pagestyle empty); so let's at least
 % change the numbering style so that we don't actually get the number...
 \emptypagenumbering
 \tableofcontents
 \cleardoublepage
 \conditionallistoffigures
 \cleardoublepage

 % Regulations require that numbering starts on the first page
 % of the abstract, being page 1
 \pagestyle{plain}
 \pagenumbering{arabic}
 \setcounter{page}{1}
 \makeabstractEnglish
 \cleardoublepage

 \ifbool{biuthesis-abbrevs}{
  \makeabbreviationsAndNotation
  \cleardoublepage
 }{ }
}

\newcommand{\makebibliography}{%
  \ifx\biuthesis@thesisbibfiles\@empty
    \PackageError{biuthesis}{%
      No bibliography files specified; a thesis must contain a bibliography.}
  \else
    \ifdefined\pdfbookmark
      % If hyperref is loaded, this will help us to more
      % easily navigate to the bibliography
      \pdfbookmark[0]{Bibliography}{bib}%
    \fi
    \bibliographystyle{\biuthesis@thesisbibstyle}%
    \bibliography{\biuthesis@thesisbibfiles}%
  \fi%
}

\newcommand{\makebackmatter}{%

 % This _should_ be done AtEndDocument, but that fails for some reason
 \ifdefined\biuthesis@havefigures
  \label{biuthesis:had-figures}
 \fi

 \clearpage
 \makebibliography

 % Note that the order of pages here will in fact be
 % the order of pages when opening the bound thesis from
 % the ``Hebrew side'', i.e. from the back cover of the English side
 % which is the front cover for the Hebrew side; thus
 % after printing, you have to take all the pages starting
 % from the Hebrew cover page, as a packet, and reverse their direction

 % We do not make the bibliography here - for now...

 \clearpage
 \pagestyle{empty}

 % We are now on the next page after the end of the main matter. We wish
 % to begin the Hebrew content - but we don't want to do this on the same
 % sheet, with English on the recto side and Hebrew on the verso; the Hebrew
 % content pages are added to the PDF in reverse direction and we wish to
 % begin 'cleanly' with the English sheets complete and left alone, so we
 % just clear the sheet
 \cleardoublepage
}

\newcommand{\makehebrewmatter}{%
 \reversepageorder
   % reversing the output page order from this point on

 % The first Hebrew page must appear with the binding to its right; but the
 % way things are so far in the document is that odd pages (recto) have
 % margins to the left. So... maybe we should \cleartoleftpage (i.e. clear
 % to the next verso)? No, this will not to. Why? For two reasons.
 %
 % First, remember the page order is reversed. The last page we get on the
 % output, being the first page we set here, must be the Hebrew cover page,
 % not a blank page.
 %
 % Second, if we \cleartoleftpage, this will mess up the  page ordering.
 % If the Hebrew pages are:
 %
 % Title verso, Empty recto, IntroPage1 verso, IntroPage2 recto
 %
 % then a \cleartoleftpage would give us the following sheets:
 %
 % Empty recto + Title verso , Empty recto + IntroPage1 verso,
 % IntroPage2 recto + nothing/empty verso
 %
 % which is not what we wanted: We get a gratuitious empty page between
 % pages 1 and 2 of the intro... so we actually have no choice but to flip
 % the margins

 \flipmargins

 \makecoverHebrew
 % We're not clearing to a verso page, since we've flipped the margins;
 % this should generate 1 empty page between the cover page and the title page
 \cleardoublepage
 \maketitleHebrew
 \cleardoublepage
 \makeacknowledgementsHebrew
 \cleardoublepage

 \pagestyle{plain}
 % We need to reset the displayed page number, but we don't want to
 % change the "real" page number, specifically for verso/recto margin
 % setting reasons; see:
 % http://tex.stackexchange.com/q/36011/5640
 %
 \displayedpagenumbering{roman}{1}

 \makeabstractHebrew
 % For some reason, if you \clearpage after the Hebrew abstract, the
%  \AtEndDocument command which is part of the auto-list-of-figures
 % generation is not run; so commenting this out
 \clearpage

 % Consider using the solution here:
 % http://tex.stackexchange.com/q/21703/5640
 %\usepackage{atbegshi}
 % and reverse the ordering of the Hebrew sheets

 \resumenormalpageorder
    % now outputting the reversed pages and resuming normal order
    % (although we have no pages left...)
}

%--------------------------------

% Commands which the class user should not directly invoke; they
% are used in \makefrontmatter and \makebackmatter
%

\newcommand{\makecoverEnglish}{%
% Front cover / cover page
 \begin{center}
  \pagestyle{empty}

  \vspace*{\stretch{1}}
  \begin{spacing}{1}
    \Huge \textbf{\biuthesis@titleEnglish}
  \end{spacing}
  \Large

  \vspace*{\stretch{1}}

  \vphantom{Research Thesis}

  \vspace*{\stretch{0.5}}

  \vphantom{\parbox{4in}{
    \normalsize
    \begin{center}
      Submitted in partial fulfillment of the requirements \\
      for the degree of \biuthesis@degreeEnglish
    \end{center}
  }}


  \vspace*{\stretch{2}}

  {\LARGE \textbf{\biuthesis@authorEnglish}}

  \vspace*{\stretch{3}}

  \vphantom{\parbox{3.5in}{
    \normalsize
    \begin{center}
      Submitted to the Senate \\
      of the University {\textemdash} Bar-Ilan University \linebreak
      \biuthesis@JewishDateEnglish \hspace{1cm} Ramat-Gan \hspace{1cm} \biuthesis@GregorianDateEnglish
    \end{center}
  }}
 \end{center}
}

\newcommand{\maketitleEnglish}{%
 \begin{center}
  \centerline{\includegraphics[width=.3\textwidth]{graphics/biulogo.png}} % there is no logo on official title page http://www.eng.tau.ac.il/students/forms/format.pdf
    % \textbf{\LARGE Bar-Ilan University}\\
    {\LARGE{\textbf{Bar-Ilan} University}\\}
  \vspace*{\stretch{1}}
  \begin{spacing}{1}
    \Huge \textbf{\biuthesis@titleEnglish}
  \end{spacing}
  \Large

  \vspace*{\stretch{1}}

  Research Thesis

  \vspace*{\stretch{0.5}}

  \parbox{4in}{
    \normalsize
    \begin{center}
      Submitted in partial fulfillment of the requirements \\
      for the degree of \biuthesis@degreeEnglish
    \end{center}
  }

  \vspace*{\stretch{2}}

  {\LARGE \textbf{\biuthesis@authorEnglish}}

  \vspace*{\stretch{3}}

  \parbox{3.5in}{
    \normalsize
    \begin{center}
      Submitted to the Senate \\
      of the University {\textemdash} Bar-Ilan University \linebreak
      \biuthesis@JewishDateEnglish \hspace{1cm} Ramat-Gan \hspace{1cm} \biuthesis@GregorianDateEnglish
    \end{center}
  }
 \end{center}
}

\newcommand{\makeacknowledgementsEnglish}{%

  \noindent \biuthesis@supervisionEnglish

  \ifx\biuthesis@publicationInfoEnglish\@empty
  \else
    \medskip
    \noindent \biuthesis@publicationInfoEnglish

  \fi
  \ifbool{biuthesis-includeack}{
    %\vspace*{\stretch{1}}
    \medskip

    \begin{center}
    \textbf{\Large \textsc{Acknowledgements}}
    \end{center}
    \noindent
    \biuthesis@personalAcknowledgementEnglish

    \smallskip
    \vspace*{\stretch{2}}
  }{
    \vspace*{\stretch{1}}
  }
  \noindent \biuthesis@financialAcknowledgementEnglish
}

\newcommand{\makeabstractEnglish}{%
 \chapter*{Abstract}
 \addcontentsline{toc}{chapter}{Abstract}
 \addcontentsline{cot}{chapter}{תקציר}

 \biuthesis@abstractEnglish
}

\newcommand{\makeabbreviationsAndNotation}{%
 \chapter*{Abbreviations and Notations}
 \addcontentsline{toc}{chapter}{Abbreviations and Notations}
 \addcontentsline{cot}{chapter}{רשימת קיצורים וסמלים}
 \biuthesis@abbreviationsAndNotation
}

% Like \cleardoublepage, but instead of getting you to the next recto
% page, it gets you to the next verso page; see:
% http://tex.stackexchange.com/q/11707/5640
\newcommand*{\cleartoleftpage}{%
  \clearpage
    \if@twoside
    \ifodd\c@page
      \hbox{}\newpage
      \if@twocolumn
        \hbox{}\newpage
      \fi
    \fi
  \fi
}

% Workaround for the verso -> switch triggered by our restarting of numbering;
% see:
% http://tex.stackexchange.com/q/36011/5640
%
% example:
% \displayedpagenumbering}{roman}{9}
% will make the page number printed at the bottom of the page be IX in Roman
% numerals (with X on the next page, then XI etc.) - but will not change the
% value of the 'page' counter.
%
\newcommand{\displayedpagenumbering}[2]{%
  \edef\@tempcntval{\@arabic{\value{page}}}
  \long\@namedef{@#1withoffset}##1{\csname @#1\endcsname{\numexpr ##1 - \@tempcntval + #2\relax}}%
  \pagenumbering{#1withoffset}%
  \setcounter{page}{\@tempcntval}%
}

% This is used in the workaround for the first ToC page being numbered
% without our requesting it to be
\newcommand{\emptypagenumbering}{%
  \@namedef{@emptynumbering}##1{\relax}%
  \pagenumbering{emptynumbering}%
}


\newcommand{\makecoverHebrew}{

 \begin{hebrew}
 \begin{center}
   \vspace*{\stretch{1}}
   \begin{spacing}{1}
     \Huge \textbf{\biuthesis@titleHebrew}
   \end{spacing}
   \Large

   \vspace*{\stretch{1}}

   \vphantom{חיבור על מחקר}

   \vspace*{\stretch{0.5}}

   \vphantom{\parbox{3.5in}{
     \normalsize
     \begin{center}
       לשם מילוי חלקי של הדרישות לקבלת התואר \\
       \biuthesis@degreeHebrew
     \end{center}
  }}

  \vspace*{\stretch{2}}

  {\LARGE \textbf{\biuthesis@authorHebrew}}

  \vspace*{\stretch{3}}

  \vphantom{\parbox{3in}{
     \normalsize
     \begin{center}
       מוגש לסנט האוניברסיטה {\textemdash} אוניברסיטת בר-אילן
       \biuthesis@JewishDateHebrew
       \hspace{0.75cm} רמת-גן \hspace{0.75cm}
       \biuthesis@GregorianDateHebrew
     \end{center}
  }}
 \end{center}
 \end{hebrew}
}

\newcommand{\maketitleHebrew}{
 \begin{hebrew}
 \begin{center}
  \centerline{\includegraphics[width=.3\textwidth]{graphics/biulogo.png}} % there is no logo on official title page http://www.eng.tau.ac.il/students/forms/format.pdf
    % \textbf{\LARGE Bar-Ilan University}\\
    {\LARGE{אוניברסיטת \textbf{בר-אילן}}\\}
  \vspace*{\stretch{1}}
  \begin{spacing}{1}
    \Huge \textbf{\biuthesis@titleHebrew}
  \end{spacing}
  \Large

  \vspace*{\stretch{1}}

  חיבור על מחקר

  \vspace*{\stretch{0.5}}

  \parbox{3.5in}{
    \normalsize
    \begin{center}
      לשם מילוי חלקי של הדרישות לקבלת התואר \\
      \biuthesis@degreeHebrew
    \end{center}
  }

  \vspace*{\stretch{2}}

  {\LARGE \textbf{\biuthesis@authorHebrew}}

  \vspace*{\stretch{3}}

  \parbox{4in}{
     \normalsize
     \begin{center}
       הוגש לסנט האוניברסיטה {\textemdash\relax} אוניברסיטת בר-אילן \\
       \biuthesis@JewishDateHebrew
       \hspace{0.75cm} רמת-גן \hspace{0.75cm}
       \biuthesis@GregorianDateHebrew
     \end{center}
  }
 \end{center}
 \end{hebrew}
}

\newcommand{\makeacknowledgementsHebrew}{
  \begin{hebrew}
  \noindent \biuthesis@supervisionHebrew

  \ifx\biuthesis@publicationInfoHebrew\@empty
  \else
    \medskip
    \noindent \biuthesis@publicationInfoHebrew

  \fi

  \ifbool{biuthesis-includeack}{
    %\vspace*{\stretch{1}}
    \medskip
    \begin{center}
    \textbf{\Large \textsc{תודות}}
    \end{center}
    \noindent
    \biuthesis@personalAcknowledgementHebrew

    \vspace*{\stretch{2}}
  }{
    \vspace*{\stretch{1}}
  }
  \noindent \biuthesis@financialAcknowledgementHebrew
  \end{hebrew}
}

\newcommand{\makeabstractHebrew}{
  \begin{hebrew}
  \setlist[itemize,1]{label={\fontfamily{cmr}\fontencoding{T1}\selectfont\textbullet}}
  \chapter*{\texthebrew{תקציר}}
  \addcontentsline{cot}{chapter}{תקציר עברי}
  \begin{english}
  \addcontentsline{toc}{chapter}{Hebrew Abstract}
  \end{english}
  \setlength{\parindent}{0pt}
  \setlength{\parskip}{10pt}

  \biuthesis@abstractHebrew

  \end{hebrew}
}

% ----------------------------------------------------------
%
% Commands which may be of some use in the main matter (and are
% not used in the front or back matter)
%

% The following commented-out commands have been suggested by Ido Tal,
% to overcome problems with the two-language sectioning commands; the
% pre-existing commands (which should be available - at least with LaTeX2e
% and babel, perhaps requiring some package inclusion) are:
%  \bpart{hebrew}{english}
%  \bchapter{hebrew}{english}
%  \bsection{hebrew}{english}
%  \bsubsection{hebrew}{english}
%  \bsubsubsection{hebrew}{english}
%  \bcaption{hebrew}{english}
%  \bchapternn{hebrew}{english} - replaces \chapter*
%  \bsectionnn{hebrew}{english} - replaces \section*

\endinput
