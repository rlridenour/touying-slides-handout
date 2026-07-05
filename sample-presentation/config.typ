// config.typ
// Shared configuration for both the live slide deck (sample-presentation-slides.typ) and
// the continuous handout (sample-presentation-handout.typ).
//
// content.typ defines its content as a function that takes title-slide/
// pause/slide/speaker-note/handout-note/two-column-slide/full-slide as
// parameters. Each entry point below supplies its own implementations:
// sample-presentation-slides.typ passes the real Touying building blocks (real
// pagination, animations, speaker notes); sample-presentation-handout.typ passes plain,
// non-paginating stand-ins so the whole thing renders as one flowing
// document instead of a slide deck.

#import "@preview/touying:0.7.4": *
#import "@local/basic-theme:0.1.0": (
  basic-theme,
  basic-theme-date-format,
  univ-logo,
  title-slide as live-title-slide,
  slide as live-slide,
  pause as live-pause,
  speaker-note as live-speaker-note,
  two-column-slide as live-two-column-slide,
  full-slide as live-full-slide,
)

// Presentation metadata, shared between the live title slide (which
// reads it via Touying's `self.info`) and the handout title "slide"
// (which has no Touying context and so renders it directly).
#let presentation-info = (
  title: [Sample Presentation],
  subtitle: [Typst and Touying],
  author: [Randy Ridenour],
  date: datetime.today(),
  institution: [Department of Philosophy],
)

// variant: "white" (default), "black", or "gray".
//
// slide-level: 2 (default) for a talk with no subsections (`=`
// section, `==` frame directly), or 3 if this talk uses subsections
// (`=` section, `==` subsection, `===` frame).
#let project(variant: "white", slide-level: 3, body) = {
  show: basic-theme.with(
    aspect-ratio: "16-9",
    variant: variant,
    slide-level: slide-level,
    config-common(
      show-notes-on-second-screen: right,
    ),
    config-info(
      ..presentation-info,
      logo: univ-logo(),
    ),
  )

  body
}

// Handout notes never show on the live deck.
#let live-handout-note(body) = none

// -- Handout: a single flowing document, no slide pagination ---------------

// Which heading level is the "frame" level -- must match the
// `slide-level` passed to `project()` for the live deck. Stored in a
// state (rather than a plain constant) so `handout-project`'s
// `slide-level` argument can set it and `nearest-heading-title` can
// read it back, since the two run in different function calls.
#let handout-frame-level = state("handout-frame-level", 3)

// Portrait US letter, 12pt body text; no theme/pagination machinery at
// all.
//
// slide-level: 2 (default) for a talk with no subsections (`=`
// section, `==` frame directly), or 3 if this talk uses subsections
// (`=` section, `==` subsection, `===` frame) -- must match the
// `slide-level` passed to `project()` for the live deck.
//
// Frame-level headings (slide titles) are hidden here -- they're shown
// inside handout-slide-box instead, so the title ends up inside the box
// rather than as a separate heading above it. Section (and, when
// slide-level is 3, subsection) headings are untouched: they stay
// outside any box, same as the document title, and are numbered
// (1, 1.1, 1.2, 2, ...).
#let handout-project(slide-level: 3, body) = {
  set page(paper: "us-letter")
  set text(size: 12pt)
  set heading(numbering: "1.1")
  show heading.where(level: slide-level): none

  handout-frame-level.update(slide-level)
  body
}

// The nearest frame-level heading at or before `here()`, compared by
// actual position (page, then y) rather than by page alone -- Touying's
// own `utils.display-current-heading` only compares pages, which isn't
// precise enough when several boxed slides share one handout page.
#let nearest-heading-title() = context {
  let level = handout-frame-level.get()
  let loc = here().position()
  let candidates = query(heading.where(level: level)).filter(h => {
    let p = h.location().position()
    p.page < loc.page or (p.page == loc.page and p.y <= loc.y)
  })
  if candidates.len() > 0 { candidates.last().body } else { none }
}

// Every "slide" in the handout is boxed like this, with its title (the
// nearest preceding frame-level heading) shown inside the box, so it's
// visually clear where one slide ends and the next begins in the
// flowing document. `breakable: false` keeps a slide's content from
// splitting across a page break.
#let handout-slide-box(body) = block(
  width: 100%,
  inset: 1em,
  stroke: 0.5pt + gray,
  radius: 2pt,
  breakable: false,
  above: 1.5em,
  below: 1.5em,
  [
    #text(weight: "bold", size: 1.1em, nearest-heading-title())
    #v(0.8em)
    #body
  ],
)

// The document title is not a "slide" in the same sense as the others
// -- kept outside any box, same as section/subsection titles.
#let handout-title-slide() = align(center)[
  #text(size: 1.4em, weight: "bold", presentation-info.title)

  #if presentation-info.subtitle not in (none, []) {
    text(size: 1.15em, weight: "bold", presentation-info.subtitle)
  }

  #v(0.5em)

  #presentation-info.author

  #presentation-info.institution

  #presentation-info.date.display(basic-theme-date-format)
]

// No animation reveal in a flowing document: everything is simply shown.
#let handout-pause = none

// A multi-subslide callback slide becomes one block showing the final
// subslide's state.
#let handout-slide(repeat: auto, ..bodies) = handout-slide-box({
  let n = if repeat == auto { 1 } else { repeat }
  bodies
    .pos()
    .map(b => if type(b) == function { b((subslide: n)) } else { b })
    .sum(default: none)
})

// Speaker notes are presenter-only; never shown in the handout.
#let handout-speaker-note(body) = none

// A plain two-up grid; there's no pagination to preserve here.
#let handout-two-column-slide(columns: (1fr, 1fr), gutter: 2em, ..bodies) = handout-slide-box(grid(
  columns: columns,
  gutter: gutter,
  ..bodies.pos(),
))

// There's no full-bleed page in a flowing document, and a `100%` height
// inside body would otherwise resolve against the whole rest of the
// page -- bound it to a fixed-height box instead, so the graphic shows
// inline at a sane size.
#let handout-full-slide(fill: auto, body) = handout-slide-box(
  box(width: 100%, height: 300pt, clip: true, body),
)

// Handout notes read as ordinary body text, with no visual marker
// distinguishing them from the rest of the article.
#let handout-note(body) = body
