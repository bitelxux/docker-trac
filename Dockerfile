# Bitelxux-Sept-2016

FROM ubuntu:16.04
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
RUN pip install reportlab html5lib pypdf
RUN pip install trac mysql-python
RUN pip install docutils
RUN pip install pygments

RUN trac-admin /var/trac initenv project sqlite:db/trac.db
RUN echo "#!/bin/bash" > /usr/local/bin/start_trac.sh
RUN echo '/usr/local/bin/tracd --port 8000 /var/trac' >> /usr/local/bin/start_trac.sh
RUN chmod +x /usr/local/bin/start_trac.sh

# wysiwyg
RUN easy_install https://trac-hacks.org/svn/tracwysiwygplugin/0.12
RUN trac-admin /var/trac config set components tracwysiwyg.* enabled

# pdf preview
RUN easy_install https://trac-hacks.org/svn/pdfpreviewplugin/1.0/
RUN trac-admin /var/trac config set components tracpdfpreview.pdfpreview.pdfrenderer enabled

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

# tracpath theme
RUN easy_install https://trac-hacks.org/svn/tracpaththeme/0.12
RUN trac-admin /var/trac config set components tracpaththeme.* enabled

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
RUN apt-get install -y openjdk-8-jre-headless
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

# permissions
RUN trac-admin /var/trac permission add admin TRAC_ADMIN
ADD set_password.py /tmp/
RUN python /tmp/set_password.py /var/trac admin passw0rd

# cache directory
RUN mkdir -p /var/trac/files/cache

# Increase maximum size values
RUN sed -i 's/262144/4000000/g' /var/trac/conf/trac.ini

# logo
ADD logo.png /var/trac/htdocs/your_project_logo.png

# Move trac.ini out of the volume
RUN mv /var/trac/conf/trac.ini /etc
RUN ln -s /etc/trac.ini /var/trac/conf

# Expose the Trac port
EXPOSE 8000
CMD ["/usr/local/bin/start_trac.sh"]

