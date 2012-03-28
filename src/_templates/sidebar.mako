<ul class="nav nav-list">
    <li class="nav-header">Last 10 posts:</li>
% for post in bf.config.blog.posts[:10]:
    <li><a href="${post.path}">${post.date.year}.${"{:#02}".format(post.date.month)}.${"{:#02}".format(post.date.day)} - ${post.title}</a></li>
% endfor
</ul>
