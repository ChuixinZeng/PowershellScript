You’ll have to use –split instead of .split(). Methods like .split() and .trim() take arrays of characters instead of strings. What happened to you is that your pattern, “my”, was treated as an array of characters and “this is my amazing string” was split on all of the “m”s and “y”s in the string. Use the –split method instead.

example:

“this is my amazing string” -split “my”