module.exports = {
  "stylesheet": [
    // "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/2.10.0/github-markdown.min.css"
  ],
  "css": `
.page-break { page-break-after: always; }
.markdown-body { font-size: 1em; }
.markdown-body pre > code { white-space: pre-wrap; }
`,
  "body_class": "markdown-body",
  "highlight_style": "monokai",
  "marked_options": {
    "headerIds": false,
    "smartypants": true,
  },
  "pdf_options": {
    // "format": "A5",
    "margin": "18mm",
    "printBackground": true
  },
  "stylesheet_encoding": "utf-8"
}