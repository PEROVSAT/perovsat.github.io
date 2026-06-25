# How to Add Documentation Pages
## Setup
### 1. Get GitHub Access
Any admin of the PEROVSAT GitHub can add you, and they have to make you a member of the Website team

### 2. Navigate to the Repository
[PEROVSAT Website Repository](https://github.com/PEROVSAT/perovsat.github.io)

### 3. Open the Editor
Once you're on the GitHub page, press "." on your keyboard, which will open a VSCode editor tab

Authorize it to use your GitHub when it asks

## File Navigation
The repository has both the PEROVSAT main website and documentation website, so you'll need to find the right place to make your documentation.

In the "Explorer" window on the side, open "docs," then "content," then either "hardware" or "software," depending on which you're writing

From here, all folders directly create webpages on the documentation site. You should be able to see the folders and files in this directly correspond to the pages on the public website

## Adding Documents
Within the Hardware and Software sections, you can create files or folders. All files should be `.md` (Markdown Files)

Once you're editing a file, you can click the preview button to see what your document will approximately look like when published. It looks like a square with a line down the middle and a magnifying glass on the side

## Markdown Basics
### Title
The first line in the file should be a title for the document. This is what will also appear as the title in the sidebar.
```md
# This is a Document Title, it goes on the first line
```

From there, you can make subheaders with `##` and keep adding `#` symbols to make lower header levels.

### Links

A link can be done like so:
```md
[Link Text](https://example.com)
```

The links can also be used to reference other files relative to this one. To go up to the folder above, you can use `..`

For example, here is a link to the "getting started" tutorial in flight software, relative to this document:
[Getting Started](../../flight/tutorials/getting-started.md)
```md
[Getting Started](../../flight/tutorials/getting-started.md)
```

### Notes and Warnings
Though they will not render in the VSCode preview, our website supports little note blocks that look like the following called Admonitions.

!!! note "Admonitions Types"
    Admonitions support note, tip, important, caution, and warning types

```markdown
!!! note "Admonitions Types"
    Admonitions support note, tip, important, caution, and warning types
```

## Publishing Documents
When your edits or additions are ready to go up on the site, navigate to the "Source Control" tab on the VSCode sidebar. Under changes, click the "+" symbol on anything you changed that you would like to publish.

When everything is added, add a short message about what you changed, and click commit and push.

After giving the website a minute to process, you should be able to reload it and view your new documentation.
