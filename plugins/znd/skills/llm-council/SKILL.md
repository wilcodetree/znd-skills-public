---
name: llm-council
description: Convene a council of independent agents that answer a hard question separately, blind-review and rank each other's answers, then synthesize one vetted answer, fighting sycophancy and one-angle reasoning. Two modes, default (5 Claude sub-agents) and cross-vendor (real GPT/Gemini/Claude/Grok via OpenRouter, faithful to karpathy/llm-council). Trigger on "/llm-council", "convene the council", "run this through the council", "get a multi-model / second opinion", "stress-test this", "don't just agree with me", "argue both sides and tell me who's right", "is this actually a good idea", or any moment the user wants a decision pressure-tested rather than rubber-stamped. Use cross-vendor mode on "cross-vendor", "real models", "different providers", "use openrouter", "faithful council", or a `--cross-vendor` / `--openrouter` flag.
---

# LLM Council

A 3-stage pipeline (after karpathy/llm-council) that produces a vetted answer
instead of a sycophantic one. Independent agents answer **blind**, then
**blind-review and rank** each other's work, then the main loop (you, as
Chairman) **synthesizes**. The win is blind peer review across independent
reasoners: judge on merit, no one knows whose answer is whose.

## When to use this skill

- `/llm-council`, "convene the council", "run this through the council", "get a
  multi-model / second opinion", "stress-test this", "don't just agree with me",
  "argue both sides and tell me who's right", "is this actually a good idea"
- Any moment the user wants a decision pressure-tested rather than rubber-stamped

## Pick a mode before Stage 1

- **Default (Claude council).** Five `opus` sub-agents, different lenses. Fast,
  free, no external calls, no question leaves Anthropic. Run this unless the user
  asks for the other one.
- **Cross-vendor (faithful council).** Real different providers, GPT, Gemini,
  Claude, Grok, via OpenRouter, exactly as karpathy/llm-council intended.
  Trigger: "cross-vendor", "real models", "different providers", "use
  openrouter", "faithful council", or `--cross-vendor` / `--openrouter`. This
  **sends the question to OpenAI/Google/xAI** and costs money, so it is opt-in
  only: never silently upgrade the default into it.

The real win of cross-vendor is catching **correlated blind spots**: things
every Claude gets wrong the same way. The default catches weak reasoning and
one-angle answers but shares Claude's blind spots; the faithful council does not.

**The question** is whatever the user passed (the `/llm-council` arg, or the thing
he asked you to run through the council). If it is vague, ask one clarifying
question first: a sharp question is worth more than five answers to a fuzzy one.

---

## Default mode

### Stage 1. Independent answers (5 members, in parallel)

Spawn **all five Agent calls in a single message** (one block, five tool calls)
so they run concurrently. Each is a `general-purpose` agent on **`opus`**, every
seat gets the smartest model. Give each the **same question** plus its lens.
Members never see each other.

| Member | model | Lens (what it's told to prioritize) |
|---|---|---|
| Pragmatist | `opus` | What actually works under real constraints. Bias to action and the concrete next move. |
| Red-teamer | `opus` | Attack the premise. Where does this fail? Is the question itself wrong or missing something? |
| Domain rigorist | `opus` | Technical correctness and precision. Name the real tradeoffs exactly; no hand-waving. |
| First-principles | `opus` | Ignore convention and best-practice. Reason up from fundamentals; question defaults. |
| Generalist | `opus` | Breadth. Connect angles, weigh the whole picture, answer plainly. |

Diversity comes from the **lenses**, not from weaker models: a dumber model is
noise, not a fresh perspective. Member count and lenses are easy to tune later.

Prompt template for each member:

> You are one member of an expert council answering a question independently.
> Your job is to give your **genuine best answer**, the lens below is what you
> should *emphasize*, not a character to perform.
>
> **Your lens:** {lens}
>
> **Question:** {question}
>
> Give a direct, well-reasoned answer. State your key assumptions and the
> strongest objection to your own position. Be specific and concise: no
> preamble, no hedging. You may use read-only tools if you genuinely need a
> fact to answer well, but lead with reasoning.
>
> Return only your answer.

Collect the five answers verbatim.

Complete when: all five member answers are collected verbatim, none dropped.

### Stage 2. Blind peer review and ranking (5 reviewers, in parallel)

Label the five Stage 1 answers `Response A`, `Response B`, ... `Response E` and
**strip all identity** (no lens names, no model names). Keep your own private
map of label to member for the notes later.

Spawn **five reviewer Agent calls in one message**, all on **`opus`** (judging
answer quality is harder than producing it: never cheap out on the judges).
Each reviewer sees **all five anonymized answers**. Reviewers are fresh
stateless spawns, none can recognize "its own" answer, so there is no
self-preference bias.

Reviewer prompt template:

> You are evaluating anonymized answers to this question:
>
> **Question:** {question}
>
> {Response A ... Response E, each as "Response X:\n{answer}"}
>
> Your task:
> 1. Evaluate each response individually, what it does well, what it does
>    poorly, judging on **accuracy and insight only**, not style or length.
> 2. Then give a final ranking, best to worst.
>
> Format the ranking EXACTLY like this at the very end:
>
> ```
> FINAL RANKING:
> 1. Response C
> 2. Response A
> 3. Response E
> 4. Response B
> 5. Response D
> ```
>
> Only response labels in the ranking section, no extra text there.

Parse each `FINAL RANKING:` block. Aggregate by average position (lower is
better) to get the council's overall order.

Complete when: all five `FINAL RANKING` blocks are parsed and an aggregate
order is computed. A reviewer whose block does not parse is dropped from the
aggregate, not treated as a blocker.

---

## Cross-vendor mode (faithful council via OpenRouter)

Only when the user opted in (see "Pick a mode before Stage 1"). This replaces
Stages 1 and 2 with a real multi-provider fan-out; Stage 3 below is unchanged,
you still synthesize as Chairman.

The script `scripts/council_openrouter.py` (pure stdlib) does the work: it
calls every council model in parallel for its independent answer (Stage 1),
then sends each model all the **anonymized** answers and parses its
`FINAL RANKING` (Stage 2), then prints one JSON blob: answers (de-anonymized
back to their model), reviews, and the aggregate ranking.

**Run it** from the project dir (so it finds `.env`):

```
python3 ~/.claude/skills/llm-council/scripts/council_openrouter.py "the exact question"
```

Default lineup is the original Karpathy council, editable as `COUNCIL_MODELS`
at the top of the script:

| Seat | OpenRouter slug |
|---|---|
| GPT | `openai/gpt-6-astra` |
| Gemini | `google/gemini-3.1-pro-preview` |
| Claude | `anthropic/claude-opus-5.5` |
| Grok | `x-ai/grok-4.3` |

Then:

1. **Read the JSON.** `members[]` already maps each answer back to its real
   model. `aggregate_ranking[]` is best-first by average peer rank.
2. **Be Chairman (Stage 3, same rules as default mode).** Synthesize on merit
   and consensus across vendors: graft strong points even from low-ranked
   seats; where vendors genuinely split, say so and take a side; if any model
   showed the premise is wrong, that leads.
3. **Output (same format as default mode),** but in the council note name the
   **models** (`GPT > Claude > Grok > Gemini`), and call out anything where the
   vendors **diverged**: that divergence is the whole point of paying for this
   mode.

Failure branches, read from the script's JSON output:

- `error` field present: relay it. The common one is a missing
  `OPENROUTER_API_KEY`: tell the user to add `OPENROUTER_API_KEY=sk-or-...` to the
  project `.env` (get it at openrouter.ai/keys), then re-run.
- `failures[]` non-empty: one or more model slugs failed (often a
  renamed/retired slug returning HTTP 404). Note which seat dropped; if 2 or
  more members still answered, the council is still valid, continue to Stage 3.
  Fewer than 2 answered: stop, do not synthesize from a single seat, tell the user
  which slugs failed and fix `COUNCIL_MODELS`.
- Want a single-model chairman instead of you? Pipe the question and answers to
  one more `--models` call (e.g. `--models "google/gemini-3-pro-preview"`). Not
  the default: you, the orchestrator with full context, are the better Chairman.

Complete when: the JSON has 2 or more members with answers and an
`aggregate_ranking`, or you have relayed the `error` and stopped.

---

## Stage 3. Chairman synthesis (you, the main loop, both modes)

You now hold all five answers and all five reviews (or the cross-vendor
equivalent). Do **not** just pick the number 1 answer, and do **not** drift
back toward whatever the user originally implied: synthesize on **merit and
consensus**.

- Build the final answer from the strongest reasoning across all members,
  grafting good points even from low-ranked answers.
- Where the council genuinely splits, **say so and take a position**, do not
  average the disagreement into mush.
- If the Red-teamer (or anyone) showed the question's premise is wrong,
  **that leads.** The council exists to push back, not rubber-stamp.

Complete when: the synthesized answer states a position, names any real
disagreement and which side you took, and does not simply restate the
top-ranked member's answer.

---

## Output (respect the anti-fluff rules)

Lead with the answer. Keep the council note tight.

1. **The answer**: the synthesized recommendation, stated plainly and directly.
2. **Council notes**, 3 to 5 lines max:
   - where they agreed
   - the one real disagreement (and which side you took, why)
   - the aggregate ranking (e.g. `Pragmatist > Rigorist > First-principles > Generalist > Red-teamer`)
   - anything you overrode and why

Do **not** dump the five full answers by default. If the user says "show me each
member" or "show the work", print the per-member answers and full reviews then.

## Notes and limits

- **Default mode shares Claude's blind spots.** Every member is Claude, so it
  catches weak reasoning, bad assumptions, and one-angle answers, but not blind
  spots all Claude models share. Reach for **cross-vendor mode** when the
  stakes justify the API cost and you specifically want a non-Claude check on
  the premise.
- **Cross-vendor sends the question off-Anthropic** to OpenAI/Google/xAI via
  OpenRouter and costs real tokens. Opt-in only: never auto-upgrade the default.
- Member count and lenses (default) or model list (cross-vendor) are easy to
  tune: the defaults are defaults, not laws. For a quick gut-check, 3 members is
  fine; for a high-stakes call, keep the full council.
- **Cost lever: advisor-strategy.** All ten Agent calls (five members, five
  reviewers) currently run on `opus`. Anthropic's own benchmark for the pattern
  (a cheap model does the work, an expensive model only reviews it) has Sonnet 5
  with a Fable/Opus advisor land within 10% of Fable-alone quality at 63% of the
  price. Not switched on by default here since judging answer quality is the one
  place this skill deliberately never cheaps out (see Stage 2), but worth a
  deliberate trial if a run needs to be cheaper: members on `sonnet`, reviewers
  stay on `opus`.

