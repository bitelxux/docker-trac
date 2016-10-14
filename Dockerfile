# Javalinas-Bitelxux Sept-Oct-2016

FROM debian:latest
MAINTAINER bitelxux

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Make sure the repository information is up to date
RUN apt-get update

RUN apt-get install -y cron
RUN apt-get install -y wget
RUN apt-get install -y python-pip
RUN apt-get install -y libmysqlclient-dev
RUN apt-get install -y subversion
RUN apt-get install -y git
RUN apt-get install -y vim
RUN apt-get install -y graphviz
RUN apt-get install -y python-imaging
RUN apt-get install -y python-dev
RUN apt-get install -y docutils-common
RUN pip install reportlab html5lib pypdf
RUN pip install pip --upgrade
RUN pip install trac mysql-python
RUN pip install pygments
RUN pip install docutils
RUN pip install trac --upgrade

RUN mkdir -p /var/trac

RUN trac-admin /var/trac initenv project sqlite:db/trac.db

# newsflash
RUN easy_install https://trac-hacks.org/svn/newsflashmacro/0.11
RUN trac-admin /var/trac config set components newsflash.* enabled

# autocomplete
RUN easy_install https://trac-hacks.org/svn/wikiautocompleteplugin
RUN trac-admin /var/trac config set components wikiautocomplete.web_ui.wikiautocompletemodule enabled

# wysiwyg
RUN easy_install https://trac-hacks.org/svn/tracwysiwygplugin/0.12
RUN trac-admin /var/trac config set components tracwysiwyg.* enabled

# pdf preview
RUN easy_install https://trac-hacks.org/svn/pdfpreviewplugin/1.0/
RUN trac-admin /var/trac config set components tracpdfpreview.pdfpreview.pdfrenderer enabled

# enable git repositories
RUN trac-admin /var/trac config set components tracopt.versioncontrol.git.* enabled

# githubsync
RUN pip install GitHubSyncPlugin
RUN trac-admin /var/trac config set components githubsync.api.* enabled

# include macro
RUN easy_install https://trac-hacks.org/svn/includemacro/trunk/
RUN trac-admin /var/trac config set components includemacro.* enabled

# wikiextras
RUN easy_install https://trac-hacks.org/svn/wikiextrasplugin/trunk
RUN trac-admin /var/trac config set components tracwikiextras.* enabled

# toc macro
RUN easy_install https://trac-hacks.org/svn/tocmacro/0.11
RUN trac-admin /var/trac config set components tractoc.* enabled

# wikiprint
RUN easy_install https://trac-hacks.org/svn/tracwikiprintplugin/1.0
RUN trac-admin /var/trac config set components wikiprint.* enabled

# fullblog
RUN easy_install https://trac-hacks.org/svn/fullblogplugin
RUN trac-admin /var/trac config set components tracfullblog.* enabled
RUN trac-admin /var/trac upgrade

# tractheme engine
RUN pip install TracThemeEngine
RUN trac-admin /var/trac config set components themeengine.* enabled

# codeexample macro
RUN easy_install https://trac-hacks.org/svn/codeexamplemacro
RUN trac-admin /var/trac config set components codeexample.code_example_processor.* enabled

# graphviz
RUN easy_install https://trac-hacks.org/svn/graphvizplugin/trunk
RUN trac-admin /var/trac config set components graphviz.graphviz.graphviz enabled

# accountmanager
RUN easy_install https://trac-hacks.org/svn/accountmanagerplugin/tags/acct_mgr-0.4.4
RUN trac-admin /var/trac config set components acct_mgr.* enabled
RUN trac-admin /var/trac config set components trac.web.auth.LoginModule disable
RUN echo '' >> /var/trac/conf/trac.ini
RUN echo '[account-manager]' >> /var/trac/conf/trac.ini
RUN echo 'password_store = HtPasswdStore' >> /var/trac/conf/trac.ini
RUN echo 'htpasswd_hash_type =' >> /var/trac/conf/trac.ini
RUN echo 'htpasswd_file = /var/trac/.htpasswd' >> /var/trac/conf/trac.ini

# plantuml
RUN easy_install https://trac-hacks.org/svn/plantumlmacro/trunk
RUN apt-get install -y openjdk-7-jre-headless
RUN wget http://sourceforge.net/projects/plantuml/files/plantuml.jar/download -O /opt/plantuml.jar
RUN trac-admin /var/trac config set components plantuml.* enabled
RUN echo '' >> /var/trac/conf/trac.ini
RUN echo '[plantuml]' >> /var/trac/conf/trac.ini
RUN echo 'plantuml_jar = /opt/plantuml.jar' >> /var/trac/conf/trac.ini

# sensitive tickets
RUN easy_install https://trac-hacks.org/svn/sensitiveticketsplugin
RUN trac-admin /var/trac config set components sensitivetickets.sensitivetickets.sensitiveticketspolicy enabled
RUN sed -i 's/permission_policies =/permission_policies = SensitiveTicketsPolicy,/g' /var/trac/conf/trac.ini
RUN trac-admin /var/trac upgrade

# multiproject
RUN easy_install https://trac-hacks.org/svn/simplemultiprojectplugin
RUN trac-admin /var/trac config set components simplemultiproject.* enabled
RUN sed -i 's/permission_policies =/permission_policies = ProjectTicketsPolicy,/g' /var/trac/conf/trac.ini
RUN sed -i 's/\[ticket-custom\]/\[ticket-custom\]\nproject = select\nproject.label = Project\nproject.value =/g' /var/trac/conf/trac.ini
RUN trac-admin /var/trac upgrade

# private wikis
RUN easy_install https://trac-hacks.org/svn/privatewikiplugin/trunk/
RUN trac-admin /var/trac config set components privatewiki.api.privatewikisystem enabled
RUN sed -i 's/permission_policies =/permission_policies = PrivateWikiSystem,/g' /var/trac/conf/trac.ini
RUN echo "" >> /var/trac/conf/trac.ini
RUN echo "[privatewikis]" >> /var/trac/conf/trac.ini
RUN echo "private_wikis = " >> /var/trac/conf/trac.ini

# permissions
RUN trac-admin /var/trac permission add admin TRAC_ADMIN
ADD set_password.py /usr/local/bin
RUN chmod +x /usr/local/bin/set_password.py
RUN /usr/local/bin/set_password.py /var/trac admin passw0rd

# cache directory
RUN mkdir -p /var/trac/files/cache

# Increase maximum size values
RUN sed -i 's/262144/4000000/g' /var/trac/conf/trac.ini

# Set minimum username length to 3
RUN sed -i 's/\[account-manager\]/\[account-manager\]\nusername_regexp = (?i)^\[A-Z0-9.\\-_\]{3,}$/g' /var/trac/conf/trac.ini

# logo
ADD logo.png /var/trac/htdocs/your_project_logo.png

# Move trac.ini out of the volume
RUN mkdir /etc/trac
RUN mv /var/trac/conf/trac.ini /etc/trac
RUN chmod 700 /etc/trac/trac.ini
RUN ln -s /etc/trac/trac.ini /var/trac/conf

# Install apache-ssl
RUN apt-get install -y apache2 libapache2-mod-python openssl

# Set ssl certificates
RUN mkdir -p /etc/ssl/private
RUN mkdir -p /etc/ssl/certs
COPY trac_ssl.key /etc/ssl/private/trac.key
COPY trac_ssl.crt /etc/ssl/certs/trac.crt
RUN chmod 400 /etc/ssl/private/trac.key /etc/ssl/certs/trac.crt

# permisions
RUN chown www-data:www-data /etc/trac -R
RUN chown www-data /var/trac -R
COPY apache2/apache2.conf /etc/apache2/apache2.conf

# Set only https
RUN sed -i "s/Listen 80/Listen 443/g" /etc/apache2/ports.conf
RUN rm /etc/apache2/sites-enabled/000-default.conf

# Enable ssl
RUN ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/
RUN ln -s /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/
RUN ln -s /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled

# Enable trac
RUN mkdir -p /etc/apache2/conf.d
COPY apache2/trac.conf /etc/apache2/conf.d

RUN ln -s /etc/apache2/conf.d/ssl.conf /etc/apache2/sites-enabled/ssl.conf
RUN ln -s /etc/apache2/conf.d/trac.conf /etc/apache2/sites-enabled/trac.conf

COPY apache2/ssl.conf /etc/apache2/conf.d/
COPY apache2/ports.conf /etc/apache2/

# tracpath theme
RUN easy_install https://trac-hacks.org/svn/tracpaththeme/0.12
RUN trac-admin /var/trac config set components tracpaththeme.* enabled

# tseve theme
RUN easy_install https://trac-hacks.org/svn/tsevetheme
RUN trac-admin /var/trac config set components tsevetheme.* enabled

# Expose the Trac ports
EXPOSE 443
EXPOSE 80
CMD /usr/sbin/service apache2 start && tail -F /var/log/apache2/error.log

