// content.typ
// Slide content for Sample Presentation, written once as a function of its building
// blocks so it can render either as live Touying slides (*-slides.typ) or
// as a flowing handout (*-handout.typ).
//
// Plain content under a heading needs no wrapper; only speaker-note/
// handout-note (which must differ between the live deck and the
// handout) and the two special layouts (two-column-slide, full-slide)
// are explicit calls.

#let content(
    title-slide,
    pause,
    speaker-note,
    handout-note,
    two-column-slide,
    full-slide,
) = [
    #title-slide()

    #speaker-note[

        Note for title slide.
    ]

    = Section

    == Subsection

    === Files


    + config.typ
    + content.typ
    + slides.typ
    + handout.typ


    #speaker-note[
        - config.typ contains all configuration information.
            - Includes title info and desired theme variants.
        - content.typ is the content file shared by both slides.typ and handout.typ.
        - slides.typ and handout.typ are compiled to produce the slides and handout.
    ]

    #handout-note[
        This is a handout note. They are used for producing detailed handouts that compile as article type documents. Handout notes only appear in the handouts; they are never part of the slide content.

        My goal here was to replicate a LaTeX workflow of using Beamer to produce slides and article-format handouts from a single content file. The configuration file requires very minimal editing:

        - Change the title, author, etc. in the `#let presentation-info` section.
        - Change any desired variants in the `#let-project(variant: "white", slide-level: 3, body)` line.

        The content.typ file contains the content shared by both the slides and the handout. The slides.typ and handout.typ are the files compiled to produce the final documents.
    ]

    === Heading Structure


    - Structure includes
        - Slides
        - Sections
        - Subsections (optional)


    #speaker-note[
        - All presentations have sections and slides
        - Sections, subsections, and slides are designated by the heading level.

    ]

    #handout-note[
        Sections are designated by level-one headings. Slides can be either level-two or level-three, depending on the value of the "slide-level" variant in the config.typ file. Note that changing the slide level requires changing three lines in config.typ:

        + `#let project(variant: "white", slide-level: 3, body) = {`
        +  `#let handout-frame-level = state("handout-frame-level", 3)`
        +  `#let handout-project(slide-level: 3, body) = {`
    ]

    === Slide Content


    - Anything not contained in a `note[]` wrapper becomes slide content.
    - Speaker notes in `#speaker-note[ ]`


      #speaker-note[
          
          - Standard Typst syntax used.
      ]

      #handout-note[
          The `#slide[ ]` function can be omitted, as far as I can tell. The only consequence will be that the handout won't have the box designating the slide. If you don't want to produce the handout, then feel free to omit `#slide[ ]`.


      ]

    = Special Slides

    == Types


    === Gradual Reveal


    - Use `#pause` to hide content. #pause
    - Which is then revealed by paging forward.


    #speaker-note[
        - Use `#pause` to gradually reveal content.
    ]

    #handout-note[
        The `#pause` function can be used to gradually reveal slide content.
    ]



    === Two Column Slide

    #two-column-slide[
        - Point 1
        - Point 2
    ][
        - Point 3
        - Point 4
    ]

    #speaker-note[
        - Two-column slides are simple.
    ]

    #handout-note[
        It's helpful sometimes to use two columns for slides. They're very simple to form.

        The next slide is an example of a full-frame slide with no visible title.
    ]

    === Full-Frame Graphic

    #full-slide(image("school-athens.jpg", width: 100%, height: 100%, fit: "cover"))

    #speaker-note[
        - It's helpful to sometimes use slides that do not display a title. The #full-slide function makes this simple.
        - Here's an example with an image.
    ]

    #handout-note[
        This is Raphael's "School of Athens" displayed as a full-frame image.
    ]

    === Full-Frame Text

    #full-slide(
        align(center + horizon)[
            #text(size: 3em)[*Main Point!*
            ]
        ]
    )



    #speaker-note[
        - Also helpful for emphasizing key points.
    ]

    #handout-note[
        Full-frame slides are sometimes also useful for text, especially for emphasizing something that students especially need to note.
    ]


    = Conclusion

    == Assessment


    === Typst vs Beamer


    #two-column-slide[
        *Typst*

        - Instant compilation
        - Helpful error messages
        - Messier content file
    ][
        *Beamer*

        - Better use of Org mode
        - Simple content file
        - Slow compilation
    ]

    #speaker-note[
        - The main advantages of Typst are compilation speed and readable error messages.
        - The main advantage of Beamer is that Emacs Org mode Beamer export is superb.
    ]

    #handout-note[
        Making slides with Typst is much easier than making Beamer slides with LaTeX. The Typst syntax is very similar to a lightweight markup language like Markdown. Beamer has a signifanct advantage for Emacs users, however. Beamer export in Emacs Org mode is excellent. Typst can be used with Org mode with the Ox-Typst package. The next task will be to try to write the content file in Org Mode and export to typst.typ.

    ]

]
