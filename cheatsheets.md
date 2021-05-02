---
layout: article
title: Cheatsheets
permalink: /cheatsheets
---

Some cheatsheets I've made while learning programming languages. 
They are intended to be printed in a "boolket" format, and be kept within reach while coding.

{% for cheatsheet in site.cheatsheets %}
  * <a href="{{ cheatsheet.url }}">{{ cheatsheet.title }}</a>
{% endfor %}