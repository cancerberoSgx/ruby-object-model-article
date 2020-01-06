module.exports = {
  stylesheet: [
    "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/2.10.0/github-markdown.min.css"
  ],
  css: `
.markdown-body pre > code { white-space: pre-wrap; }
.markdown-body { font-size: 1em; }
.page-break { page-break-after: always; }
`,
  body_class: "markdown-body",
  marked_options: {
    headerIds: false,
    smartypants: true,
  },
  pdf_options: {
    margin: "14mm",
    displayHeaderFooter: true,
    headerTemplate: `
    `
  }
}