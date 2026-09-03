# Prompt template for generating an applet

Copy the text below into Claude or ChatGPT, fill in the four bracketed
parts, and paste the result into a new file in this folder.

Then **verify it** — see the checklist at the bottom. An applet that
looks convincing and computes the wrong thing is worse than no applet,
because students trust it more than they trust you.

---

## The prompt

> Write me a small interactive teaching applet as **one single,
> self-contained HTML file**.
>
> **Topic:** [WHAT IT SHOULD SHOW — e.g. "the sampling distribution of
> the mean: the student sets the population SD and the sample size n,
> draws many samples, and sees the distribution of sample means next to
> the population distribution"]
>
> **Controls:** [WHICH SLIDERS / INPUTS, AND THEIR RANGES — e.g. "sliders
> for n (1–100) and sigma (1–20), and a button that draws 500 samples"]
>
> **Language of all labels and text:** [English / Dutch]
>
> Hard requirements:
>
> - One file. All CSS and JavaScript inline. No npm, no build step, no
>   separate files.
> - **No external libraries and no CDN links.** Use plain JavaScript and
>   a `<canvas>` element for any plotting. The applet must work with no
>   internet connection.
> - It will be embedded in an iframe at `width: 100%` and
>   `height: [HEIGHT]px`. Use a responsive layout; nothing may overflow
>   or need scrolling inside the frame at that height.
> - Set the background colour explicitly on `body`. Support both light
>   and dark colour schemes via `prefers-color-scheme`.
> - Readable at phone width.
> - Put a comment at the very top of the file stating **exactly which
>   formula or algorithm you implemented**, in mathematical notation.
> - Keep it simple and readable — I need to be able to check it.
>
> Start with the simplest version that works. I will ask for additions
> afterwards.

---

## Verification checklist

Work through this every time. It takes five minutes.

- [ ] **Read the formula comment** at the top of the file. Is it the
      formula you actually teach?
- [ ] **Open the file directly** in a browser by double-clicking it. It
      must work standalone, before any iframe is involved.
- [ ] **Check three numbers against R.** Pick inputs you can compute
      yourself, including one extreme case. For a *p*-value applet:
      does it agree with `2 * pt(-abs(t), df = n - 1)`?
- [ ] **Push every slider to both ends.** n = 1, alpha = 0, r at maximum.
      This is where AI-written applets produce `NaN`, an empty plot, or
      a silent freeze.
- [ ] **Check the language and the notation** match the rest of your book.
- [ ] **Narrow the browser window** to phone width.
- [ ] **Render the book** and open the real chapter page, not the file.
- [ ] **Ask for changes one at a time.** A 500-line applet written in one
      shot is very hard to check; the same applet grown in four steps is
      easy, because each step was small when you checked it.

## Why "no CDN"

It is tempting to let the assistant use a plotting library from a CDN —
it produces prettier output faster. But it then breaks when the CDN
changes, when a student has no connection, and in any offline copy of the
book. For sliders and a plot, plain canvas is genuinely enough.
If you do accept a CDN link, pin the exact version
(`chart.js@4.4.0`, never `chart.js@latest`) and know that you have made
your book depend on somebody else's server.
