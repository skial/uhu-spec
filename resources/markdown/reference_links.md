Foo [bar] [1].

Foo [bar][1].

Foo [bar]
[1].

[1]: /url/  "Title"


With [embedded [brackets]] [b].


Indented [once][].

Indented [twice][].

Indented [thrice][].

Indented [four][] times.

 [once]: /url

  [twice]: /url

   [thrice]: /url

    [four]: /url


[b]: /url/

* * *

[this 1] [this] should work

So should [this 2][this].

And [this 3] [].

And [this 4][].

And [this 5].

But not [that 1] [].

Nor [that 2][].

Nor [that 3].

[Something in brackets like [this 6][] should work]

[Same with [this 7].]

In this case, [this 8](/somethingelse/) points to something else.

[this]: foo


* * *

Here's one where the [link
breaks] across lines.

Here's another where the [link 
breaks] across lines, but with a line-ending space.


[link breaks]: /url/


[id]: <http://example.com/>  "Optional Title Here"