---
title: Debugging python code
tags: programming python
---

A "breakpoint" in a python code to get an interactive shell somewhere in the code and make debugging easier.

<!--more-->

The `IPython` package is necessary:

```bash
$ pip install IPython
```

Then insert those lines somewhere into the code:

```python
import IPython
IPython.embed()
exit(0)
```

The code stops and an interactive shell appears, allowing to check some variables values and test some code.

