# Bitelxux - Sept 2016

FROM ubuntu:latest
MAINTAINER bitelxux

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Make sure the repository information is up to date
RUN apt-get update

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

# install trac plugins
RUN easy_install https://trac-hacks.org/svn/accountmanagerplugin/tags/acct_mgr-0.4.4
RUN easy_install https://trac-hacks.org/svn/graphvizplugin/trunk
RUN easy_install https://trac-hacks.org/svn/codeexamplemacro
RUN pip install TracThemeEngine
RUN easy_install https://trac-hacks.org/svn/fullblogplugin
RUN easy_install https://trac-hacks.org/svn/tracwikiprintplugin/1.0
RUN pip install GitHubSyncPlugin
#RUN easy_install https://trac-hacks.org/svn/pdfpreviewplugin/1.0/
#At this moment there is a bug which prevents install from the url 
#https://trac-hacks.org/ticket/12887
#So we are distributing a patched version
ADD TracPdfPreview-0.1.1-py2.7.egg /tmp
RUN easy_install /tmp/TracPdfPreview-0.1.1-py2.7.egg

# enable trac plugins
RUN trac-admin /var/trac config set components acct_mgr.* enabled
RUN trac-admin /var/trac config set components acct_mgr.web_ui.LoginModule enabled
RUN trac-admin /var/trac config set components trac.web.auth.LoginModule disable
RUN trac-admin /var/trac config set components graphviz.graphviz.graphviz enabled
RUN trac-admin /var/trac config set components codeexample.code_example_processor.* enabled
RUN trac-admin /var/trac config set components tracpdfpreview.pdfpreview.pdfrenderer enabled
RUN trac-admin /var/trac config set components tracopt.versioncontrol.git.* enabled
RUN trac-admin /var/trac config set components themeengine.* enabled
RUN trac-admin /var/trac config set components wikiprint.* enabled
RUN trac-admin /var/trac config set components githubsync.api.* enabled
RUN trac-admin /var/trac config set components tracfullblog.* enabled
RUN trac-admin /var/trac upgrade

# enable htpasswd users in AccountManager plugin
RUN echo '' >> /var/trac/conf/trac.ini
RUN echo '[account-manager]' >> /var/trac/conf/trac.ini
RUN echo 'password_store = HtPasswdStore' >> /var/trac/conf/trac.ini
RUN echo 'htpasswd_hash_type =' >> /var/trac/conf/trac.ini
RUN echo 'htpasswd_file = /var/trac/.htpasswd' >> /var/trac/conf/trac.ini

# permissions
RUN trac-admin /var/trac permission add admin TRAC_ADMIN
ADD set_password.py /tmp
RUN python /tmp/set_password.py /var/trac admin passw0rd

# cache directory
RUN mkdir -p /var/trac/files/cache

# tweak trac.ini
RUN sed -i 's/262144/4000000/g' /var/trac/conf/trac.ini

# logo
ADD logo.png /var/trac/htdocs/your_project_logo.png

# Expose the SSH port
EXPOSE 8000
CMD ["/usr/local/bin/start_trac.sh"]

