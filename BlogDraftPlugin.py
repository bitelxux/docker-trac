# -*- coding: utf-8 -*-
"""
Sample FullBlog plugin that implements 'draft' blog posts.

How to use:
- Drop the plugin into the project plugins folder (auto-enabled), or into
  a global plugins directory (from `[inherit] plugins_dir` setting. If
  installed outside a single project, the plugin must be enabled:
  `[components] blogdraftplugin.* = enabled`.
- Add the plugin as a permission policy to your trac.ini, so that the relevant
  line looks like this (put it before the DefaultPermissionPolicy):
  `[trac]`
  `permission_policies = BlogDraftPlugin,DefaultPermissionPolicy,LegacyAttachmentPolicy`
- A post is considered a draft if it has a category defined as draft using the
  relevant list setting, default is:
  `[fullblog] draft_category = draft, Draft`
- If it is a draft, only the author can access the post for viewing or
  changes. All other access is blocked.
- It will also prevent:
  - Anonymous users saving drafts (that will be chaotic).
  - Saving as draft where author is not the same as the username (as further
    access will not be possible).

License: BSD

(c) 2008 ::: www.CodeResort.com - BV Network AS (simon-code@bvnetwork.no)
"""

from trac.config import ListOption
from trac.core import *
from trac.perm import IPermissionPolicy
from tracfullblog.api import IBlogManipulator
from tracfullblog.model import BlogPost, _parse_categories

class BlogDraftPlugin(Component):
    
    implements(IPermissionPolicy, IBlogManipulator)
    
    draft = ListOption('fullblog', 'draft_categories', default='draft, Draft',
        doc="""List of categories to be considered as draft blog posts,
        only available to the author.""")
    
    # IPermissionPolicy method
    
    def check_permission(self, action, username, resource, perm):
        """ Will block access if the resource points to a draft blog post,
        and the user is different from the author. Any other variation
        is just passed on to be handled by regular permission checks. """
        if not resource:
            return
        if resource.realm == 'blog' and resource.id:
            the_post = BlogPost(self.env, resource.id, resource.version)
            for category in the_post.category_list:
                if category in self.draft and the_post.author.lower() != username.lower():
                    # Block all access regardless
                    return False

    # IBlogManipulator methods

    def validate_blog_post(self, req, postname, version, fields):
        """ If the post is a draft, just do some rudimentary checking to
        make sure the author does not shoot him/herself in the foot. """
        for category in _parse_categories(fields['categories']):
            if category in self.draft:
                if req.authname == 'anonymous':
                    return [(None, 'You need to be logged in to save as draft.')]
                elif req.authname.lower() != fields['author'].lower():
                    return [(None, "Cannot save draft for an author that isn't you.")]
        return []

    def validate_blog_comment(self, req, postname, fields):
        return []
