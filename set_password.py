import os
import sys


try:
  from trac.env import Environment
  from acct_mgr.api import AccountManager
  env = Environment(sys.argv[1])
  user, passwd = sys.argv[2], sys.argv[3]
  account_manager = AccountManager(env)
  account_manager.set_password(user, passwd)
except Exception, e:
  print "Oops !! %s" % e
  print "Usage: python set_password <env> <user> <password>"
