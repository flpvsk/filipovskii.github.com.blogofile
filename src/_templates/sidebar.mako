Last 10 posts:
<ul>
% for post in bf.config.blog.posts[:10]:
    <li><a href="${post.path}">${post.date.year}.${"{:#02}".format(post.date.month)}.${"{:#02}".format(post.date.day)} - ${post.title}</a></li>
% endfor
</ul>
