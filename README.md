Installing trac is straight forward, yes, but setting it up with all of the plugins I'd like to have takes a while ... versions, dependencies, etc ...

That's why I decided to create a Docker container in order to deploy with '''One Click''' a trac with every thing I want.

This trac contains some very cool stuff already:

* It is already served by apache2 over a secure SSL connection.
* [[http://trac-hacks.org/wiki/CodeExampleMacro|CodeExampleMacro]], which allows to add collapsible code blocks in a very cool way, either typing the code or referencing a file from one repository.
* GitHubSyncPlugin 0.1.4, for syncing GitHub repositories with local repositories ... cool
* [[https://trac-hacks.org/wiki/GraphvizPlugin|GraphvizPlugin]] To insert nice Graphivz diagrams
* [[https://trac-hacks.org/wiki/PlantUmlMacro|PlantUmlMacro]] ... Do you love UML diagrams ? With this plugin you can insert amazing UML diagrams in your wikis/blogs
* [[http://trac-hacks.org/wiki/PrivateWikiPlugin|PrivateWikiPlugin]] Allows you to have private wikis. Very handy if you want to have your very own and private stuff
* [[http://trac-hacks.org/wiki/SensitiveTicketsPlugin|SensitiveTicketsPlugin]] Allows the creation of sensitive tickets that only some people can look at
* [[http://trac-hacks.org/wiki/SimpleMultiProjectPlugin|SimpleMultiprojectPlugin]] Makes extremely easy to manage different projects
* [[http://trac-hacks.org/wiki/AccountManagerPlugin|AccountManagerPlugin]] Well ... this one is mandatory as default users management simply sucks ...
* [[http://trac-hacks.org/wiki/FullBlogPlugin|FullBlogPlugin]] May be it is not as beautiful as wordpress, but it makes really easy to write posts including code, specially if you include the code directly from a repository
* [[http://trac-hacks.org/wiki/IncludeMacro|IncludeMacro]] Another nice plugin to include different things in a wiki or blog
* [[http://trac-hacks.org/wiki/NewsFlashMacro|NewsFlashMacro]] Shows a window with whatever you want ... similar to #!box
* TracPdfPreview 0.1.2, allows the preview of a pdf without the need of download it. Nice.
* [[https://trac-hacks.org/wiki/ThemeEnginePlugin|ThemeEnginePlugin]] Yes, default trac aspect looks a little bit old. This plugin allows the use of different themes.
* [[http://trac-hacks.org/wiki/TracpathTheme|TracpathTheme]] this plugin includes some alternative themes.
* [[http://trac-hacks.org/wiki/TocMacro|TocMacro]] Almost a must ... with it you can add table of contents to your pages.
* [[http://trac-hacks.org/wiki/WikiExtrasPlugin|WikiExtrasPlugin]] Adds a lot of nice features. Check out the documentation. It is worth it !
* [[http://trac-hacks.org/wiki/TracWysiwygPlugin|TracWysiwygPlugin]] Makes the edition a little bit more comfortable.
* TseveTheme 1.0, just another cool theme. The one I'm using at https://room1408.tk
* WikiAutoComplete 1.0, offers some autocompletion when you are typing.
* [[http://www.awstats.org|Awstats]] !! This docker includes awstats statistics out of the box.

And all of this just deploying this container !!

Enjoy !!

Oct-2016 Bitelxu
