# Unicode Subsystem

## What is Unicode?

Unicode is an international character encoding standard that provides a unique number (called a code
point) for every character.

| Character | Code Point |
| ----      | ----       |
| a         | U+0061     |
| あ        | U+3042     |

It means that text can be represented by a sequence of code points.  
Note that unicode itself is not an encoding like UTF-8, UTF-16, and Shift-JIS.

```
+------------+           +-------------+            +-------+
| Characters | <-------> | Code Points | <--------> | Bytes |
+------------+  Unicode  +-------------+  Encoding  +-------+
```

## Overview

`utf8data.h` in `fs/unicode/` is generated from
[Unicode Character Database](http://www.unicode.org/Public/) at build time. If there's a diff b/w
`utf8data.h` and `utf8data.h_shipped`, the shipped header file will be updated.

Exported functions can be seen in `include/linux/unicode.h`.

## API

At a high level, the required UTF-8 operations can be described fairly simply: validate a string,
normalize a string, and compare two strings (perhaps with case folding).

### `utf8_load`/`utf8_unload`

```c
struct unicode_map *utf8_load(const char *version);
void utf8_unload(struct unicode_map *um);
```

Unicode standard comes in multiple versions (e.g. `12.0.0`) and each version is different.
Therefore, a "map" must be loaded for the Unicode version of interest via this function and should
be passed to each API.

### `utf8_normalize`/`utf8_casefold`

```c
int utf8_normalize(const struct unicode_map *um, const struct qstr *str,
                  unsigned char *dest, size_t dlen);
int utf8_casefold(const struct unicode_map *um, const struct qstr *str,
                 unsigned char *dest, size_t dlen);
```

Some characters can be represented in multiple ways. Let's take `é` as an example.

| Code Points   | UTF-8          | Normalization Form                              |
| ----          | ----           | ----                                            |
| U+00E9        | 0xC3 0xA9      | NFC: Normalization Form Canonical Composition   |
| U+0065 U+0301 | 0x65 0xCC 0x81 | NFD: Normalization Form Canonical Decomposition |

UTF-8 bytes are totally different but both of them correspond the same character `é`.
`utf8_normalize` makes it possible to equate multiple representations that have the same meaning.
Specifically, it transforms the characters according to NFD.

`utf8_casefold` normalizes the given string with the lower case conversion.

# Reference

- https://deliciousbrains.com/how-unicode-works/
- https://lwn.net/Articles/784124/
