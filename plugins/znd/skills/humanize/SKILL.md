---
name: humanize
description: Makes written text and chat replies sound like a real person wrote them, not an AI. Strips tells: em-dash overuse, AI vocabulary (delve, leverage, testament...), rule-of-three, hollow summaries, over-formatting, uniform rhythm. Covers cleanup passes, generation guidance for other skills, and chat replies, not just finished deliverables. Load on "humanize this", "make this sound less like AI", "less robotic", "more natural", "sounds AI-generated", "remove the AI tells", "make it sound like me", or when finalizing a text deliverable or substantive chat reply. Defers to writing-style/brand-voice skills on structure and terms; governs texture only.
---

# Humanize

The goal of this skill is to make text read like a thinking person wrote it, not a language model. AI-generated text has a recognizable fingerprint, not because any single word is wrong, but because the same patterns repeat across millions of outputs. A reader who has seen a lot of AI text feels it instantly, even if they can't name why. This skill removes that fingerprint, in finished documents and in ordinary conversation alike.

This is about **naturalness, not deception.** The aim is prose that earns trust because it sounds like a real analyst with a point of view, not prose engineered to fool a detector. Detector tools are unreliable and change constantly, so don't optimize for them; optimize for a sharp human reader. If you fix the patterns below, detector scores take care of themselves as a side effect.

## Research basis

These are not house taste. 2025 to 2026 research on AI-generated text backs each pattern with a measurable difference:

- **Sentence rhythm is the single strongest signal.** AI text clusters at a consistent sentence length, commonly 15 to 20 words, sentence after sentence. Human writing has "burstiness": a short sentence, then a long one that develops the idea, then another short one. GPTZero's own published methodology puts human perplexity (how unpredictable the word choices are) around 80 to 100 units against roughly 20 to 30 for GPT-4-class output, and burstiness scores around 0.6 to 1.2 for humans against 0.2 to 0.4 for AI output. Newer models are closing this gap on raw syntax, which means rhythm variation matters more over time, not less.
- **Tone skews measurably positive, formal and hedged.** A 2026 linguistic comparison of human and AI text (PMC/ScienceDirect) found AI text more structured, more motivational and more uniformly polite, while human text varies more in length, carries real negative emotion, and includes personal reference. A person is allowed to be unimpressed, uncertain or blunt; the model defaults to upbeat.
- **The AI-vocabulary list below is a confirmed statistical tell, not folklore.** Multiple 2025 to 2026 studies (see the AI-writing-tells literature and the MDPI professor-perception study) name the same handful of words as disproportionately common in model output.
- **No fixed checklist fully closes the gap.** A 2026 scrutiny study found human judges could partly tell which writers knew they were being evaluated even when the measurable text features were statistically identical between groups. Something beyond word choice and sentence shape reads as effort or stakes. Practically: specificity, an admitted weak point, and a real opinion do more work than any amount of vocabulary substitution.
- **Disclosure and naturalness are not in tension.** Research on reader perception found that labelling text as AI-authored lowers trust even when the underlying content is identical to unlabelled text; unlabelled AI text is judged about the same as human text. Where a disclosure rule applies (for example in your own writing-style skill), the fix is to make the disclosed text genuinely good, not to skip the disclosure.

## Three modes

**1. Cleanup pass.** The user hands you text (theirs or AI-drafted) and wants it humanized. Read it, find the tells in the catalog below, and rewrite. Preserve the meaning, facts, and structure of the argument; change how it's said, not what it says. Return the cleaned text. If you made judgment calls (for example, you cut a section that was pure padding), say so in one line at the end. If the text already reads human and no tell in the catalog applies, say so and return it unchanged rather than manufacturing edits to justify the pass.

**2. Generation guidelines.** When writing anything from scratch, apply this catalog as you go so the first draft is already human. Other text skills (a writing-style, document-writing or brand-voice skill) can reference this skill for the same purpose. This skill governs *texture and voice*; it does not override `writing-style` or brand-voice skills (structure, terminology, disclosure rules). When they conflict, those win: humanizing should make brand-correct text sound more human, never push it off-brand.

**3. Conversational replies.** The same catalog applies to ordinary Cowork and Claude Code chat replies, not only to files that get shipped to a customer. A status update, a progress report, or an explanation in the middle of a long session is exactly the kind of text that drifts back toward default AI register: uniform paragraphs, a summary nobody asked for, three bullet points where one sentence would do. Apply the quick checklist below before sending any reply longer than a couple of sentences, the same way you would before shipping a document.

---

## The catalog of tells

Each tell below comes with why it reads as AI, and a before, after pair. Treat these as patterns to recognize, not a word blacklist to enforce mechanically; context decides whether something is a problem.

### 1. AI vocabulary
Certain words exploded in frequency once LLMs went mainstream and now read as machine-default. The worst offenders: *delve, intricate, tapestry, pivotal, underscore, landscape, foster, testament, robust, leverage, enhance, crucial, navigate (figurative), realm, multifaceted, seamless, vibrant, nuanced, garner, myriad, harness, elevate, unlock, embark, ever-evolving.*

They aren't banned, sometimes "leverage" is the right verb, but if you see several in a paragraph, the writing reads synthetic. Reach for the plain word.

> **Before:** This pivotal shift underscores the robust, multifaceted nature of the evolving frozen-potato landscape.
> **After:** This shift matters because the frozen-potato market is changing on several fronts at once.

### 2. Negative parallelism ("It's not X, it's Y")
The single most recognizable AI construction. "It's not just a product, it's a promise." Humans use it occasionally for emphasis; AI uses it reflexively. Cut almost all of them; state the point directly.

> **Before:** This isn't just a price increase, it's a fundamental rethink of the category.
> **After:** The price increase reflects a deeper rethink of the category.

### 3. Rule of three
AI defaults to triplets: three adjectives, three clauses, three bullet items, every time. The rhythm becomes hypnotic and the third item is usually filler. Vary list lengths. Use two when two is true. Use one strong word instead of three weak ones.

> **Before:** McCain is innovative, agile, and forward-thinking in its approach.
> **After:** McCain moves faster than its competitors on new formats.

### 4. Em-dash overuse
AI scatters em dashes for punchy emphasis where a comma, period, or parentheses would serve. The tell is not the em dash itself: it is the *frequency*. If a paragraph has more than one, most should become commas or full stops. Also: AI tends to skip en dashes for ranges; use 1990-2000 and 3-2, not hyphens.

Before, written with `[em dash]` standing in for the literal character (this repo's own validator scans SKILL.md for it, so read each tag as one):

```
The launch [em dash] which exceeded targets [em dash] signals a shift [em dash] and rivals are watching.
```

**After:** The launch exceeded targets and signalled a shift. Rivals are watching.

### 5. False ranges ("From X to Y")
"From intimate startups to global giants." The structure promises a spectrum that doesn't exist; it's just two loosely related things dressed up to sound comprehensive. Name the actual things, or cut one.

> **Before:** From supply-chain resilience to consumer trends, the report covers it all.
> **After:** The report covers supply-chain resilience and shifting consumer demand.

### 6. Compulsive summaries
AI restates what it just said, even in text too short to need it: "In summary," "Overall," "In conclusion," "Ultimately." In a short email or memo, delete the recap entirely. In a long document, a real conclusion should add a "so what," not echo the body.

> **Before:** In conclusion, as discussed above, these three factors all point to growth.
> **After:** Together these point to growth, which is why I'd move budget now rather than next quarter.

### 7. Over-formatting
Bolding every key **term**, turning every list into "**Term:** definition," using bullets where two sentences would read better, emojis in headers. AI reaches for formatting when it should just write. Use formatting only where it genuinely aids scanning; default to prose. This applies to chat replies too: a status update does not need three headers and a bulleted recap.

> **Before:** **Key point:** The market is **growing**. **Risk:** Margins are **thin**.
> **After:** The market is growing, but margins are thin enough to be the real risk.

### 8. Hollow intensifiers and importance-signalling
"It is important to note," "plays a vital role," "stands as a testament," "rich history," "enduring legacy," calling things "fascinating" or "transformative." These add emphasis without information. Cut the framing and let the fact carry its own weight.

> **Before:** It is important to note that pricing plays a pivotal role in the category.
> **After:** Pricing drives the category.

### 9. Uniform rhythm and structure
Beyond word choice, AI text has a *shape*: every paragraph the same length, every sentence medium-length, every section following intro-body-summary. Real writing is asymmetric. Vary sentence length: a three-word sentence after a long one lands hard. Let one paragraph run long and the next be a single line. Lead with the point sometimes; bury it for effect other times.

> **Before:** The launch went well. The team hit every milestone on schedule. Customer feedback was largely positive. The metrics support moving to phase two.
> **After:** The launch went well, and not by luck: every milestone landed on schedule, feedback was mostly positive, and the metrics that matter for phase two are already there. One number worth flagging: churn.

### 10. Throat-clearing openers
"In today's fast-paced world," "As we navigate an increasingly complex landscape," "When it comes to." These delay the actual content. Open on the substance.

> **Before:** In today's rapidly evolving food industry, sustainability has become increasingly important.
> **After:** Sustainability is now a buying criterion, not a nice-to-have.

### 11. Adverb staging ("X quietly runs Y")
An atmospheric adverb (quietly, silently, effortlessly) dressing a plain fact as a reveal. The fact does not need mood lighting.

> **Before:** Behind the scenes, the pipeline quietly handles every edge case.
> **After:** The pipeline handles the edge cases.

### 12. The grand pronouncement
Reframing an ordinary thing as a manifesto line. Close cousin of negative parallelism (tell 2), the same reflex at paragraph scale. One earned reframe per piece at most, and it must carry a fact.

> **Before:** This roadmap isn't a plan, it's a declaration of who we want to become.
> **After:** The roadmap commits us to two products by March.

---

## What to do instead (positive voice)

Removing tells leaves a vacuum; fill it with actual voice:

- **Lead with the point.** Say the conclusion, then support it. Don't build up to it.
- **Use specific nouns and numbers.** "Volumes fell 4% in Q1" beats "performance faced headwinds."
- **Vary sentence length on purpose, in both directions.** Mix a sentence under eight words with one that runs past twenty five in the same paragraph. That spread is what "burstiness" means and it is the single most reliable human signal.
- **Let a real opinion show** where appropriate. AI hedges everything; a person commits. "I'd hold off" reads human; "there are various considerations to weigh" does not.
- **Cut throat-clearing and recaps.** Most first sentences and most last sentences of AI drafts can go.
- **Prefer plain verbs.** use, not leverage; show, not underscore; build, not foster.
- **Keep the writer's own phrasing** when humanizing someone's text; match their register, don't impose a generic "good writing" voice over theirs.
- **Say what went wrong, or what you're unsure of.** AI rarely volunteers a limitation unprompted; a person does. One honest gap reads more human than any word choice.

---

## When NOT to over-correct

Humanizing is surgical, not scorched-earth. Don't create a new, equally detectable "anti-AI" style.

- **Don't strip legitimate em dashes.** If one genuinely aids the sentence, keep it. The target is overuse, not the punctuation mark.
- **Don't mangle technical precision** to sound casual. In analytical or client work, accuracy beats folksiness. A precise term is not a "tell" just because it's formal.
- **Don't ban words outright.** "Crucial," "leverage," and the rest are fine in moderation and sometimes exactly right. Judge by density and fit, not by presence.
- **Don't inject fake personality**, slang, forced jokes, or contractions that don't match the context, into formal deliverables. Natural does not mean chatty.
- **Don't flatten the author's voice** when cleaning up their writing. Preserve quirks that are theirs; remove only the machine patterns.
- **Match the register to the audience.** A board memo and a Slack message humanize differently. Stay appropriate to the document, or the conversation.

---

## Quick checklist (for a fast pass, including chat replies)

When you just need a rapid cleanup, or a check before sending a chat reply, scan for these in order:

1. Any "it's not X, it's Y"? Then state it straight.
2. More than one em dash per paragraph? Then commas or periods.
3. Three-of-everything? Then vary the count.
4. AI-vocabulary words clustering? Then plain words.
5. "In summary / overall / it's important to note"? Then delete it.
6. Bolding or bullets where prose works, especially in a chat reply? Then unformat.
7. Throat-clearing opener? Then start on the substance.
8. Every sentence the same length? Then break the rhythm: short, then long, then short.
9. Tone uniformly upbeat with no hedge or limitation admitted? Then say the one thing that is actually uncertain or unresolved.

---

*Pattern catalog distilled from Wikipedia's "Signs of AI writing" (WikiProject AI Cleanup), plus 2025-2026 research: GPTZero's published perplexity and burstiness methodology, the PMC/ScienceDirect 2026 linguistic comparison of human and AI text, the MDPI professor-perception study, an arXiv 2026 scrutiny study on human detection under varying stakes, and ACM/arXiv research on reader trust and AI-authorship disclosure. It's a moving target: these are the durable patterns, but trust the underlying principle (sound like a thinking person) over any fixed list.*
