<ul class="nav nav-list">
    <li class="nav-header">Last 10 posts:</li>
% for post in bf.config.blog.posts[:10]:
    <li><a href="${post.path}">${post.date.year}.${self.pad(post.date.month)}.${self.pad(post.date.day)} - ${post.title}</a></li>
% endfor
</ul>

<%def name="pad(s)">${"{:#02}".format(s)}</%def>
