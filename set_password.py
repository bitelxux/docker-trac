import os
import sys

from trac.env import Environment
from acct_mgr.api import AccountManager

env = Environment(sys.argv[1])
user, passwd = sys.argv[2], sys.argv[3]
mgr = AccountManager(env)
mgr.set_password(user, passwd)
