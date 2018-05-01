# Getting Started With Markdown

Each section contains some text in a code block followed by the same text rendered in markdown.

**To link to other parts of your portal, use relative links!**

---

## Headers

```
# H1
## H2
### H3
#### H4
##### H5
###### H6
```

# H1
## H2
### H3
#### H4
##### H5
###### H6

---

## Italics, bold, and strikethrough

```
**bold** __bold__ *italic* _italic_ ~~Strikethrough~~
```

**bold** __bold__ *italic* _italic_ ~~Strikethrough~~

---

## Links

```
[Link to Google](https://www.google.com/)

This is a [link with title, hover on me!](https://www.google.com/ "Google")


**To link to other parts of your portal, use relative links!**

[Introduction](/docs/{{apiHost}}/v1/introduction)

[Home Page](/)

[Getting Started](/docs/{{apiHost}}/v1/c/Guides/Getting%20Started)
```

[Link to Google](https://www.google.com/)

This is a [link with title, hover on me!](https://www.google.com/ "Google")


**To link to other parts of your portal, use relative links!**

[Introduction](/docs/{{apiHost}}/v1/introduction)

[Home Page](/)

[Getting Started](/docs/{{apiHost}}/v1/c/Guides/Getting%20Started)

---

## Horizontal Rules

```
---
***
___
```

---
***
___

## Lists

```
1. First
2. Second

- Entry
- Entry
  - Sub-entry
    - Sub-sub-entry
```

1. First
2. Second

- Entry
- Entry
  - Sub-entry
    - Sub-sub-entry

*You can use asterisks, minuses, or pluses for unordered lists.*

---

## Code

````
```
const myString = 'Hello World';
console.log(myString);
```
````

```
const myString = 'Hello World';
console.log(myString);
```

---

## Tables

```
| Column 1 | Column 2 | Column 3 |
| -------- | -------- | -------- |
| Foo      | Bar      | Baz      |
```

| Column 1 | Column 2 | Column 3 |
| -------- | -------- | -------- |
| Foo      | Bar      | Baz      |

---

## Images

```
This is an image:
![alt text](https://cloud.google.com/_static/4d0ad1dc9e/images/cloud/gcp-logo.svg "Title that appears on hover")
```

This is an image:
![alt text](https://cloud.google.com/_static/4d0ad1dc9e/images/cloud/gcp-logo.svg "Title that appears on hover")

---

## Blockquotes

```
> Blockquotes look like this

> And
>> Can
>>> Nest
```

> Blockquotes look like this

> And
>> Can
>>> Nest
