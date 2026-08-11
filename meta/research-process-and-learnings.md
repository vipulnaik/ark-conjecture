# Research process and learnings

This is a (fully human-written) meta document on the research process
involved in work on the Aanderaa-Rosenberg-Karp conjecture (ARK
conjecture) as well as learnings that might be interesting to others
using LLMs for research.

This document is written in first person by Vipul Naik, who did a lot
of the initial research using LLMs (primarily Claude).

## Raw materials available

As of 2026-08-11, the research is still in process, so the raw
material guidance may get out of date.

The current document is a selected set of human observations. If you
want to look at the raw materials yourself, here is some guidance:

* The outputs from Claude can be found in relevant subfolders of the
  [ark-conjecture
  repo](https://github.com/vipulnaik/ark-conjecture). The `meta`
  subfolder is human-written, but the `notes`, `scripts`, and
  `outputs` subfolders are all files output by Claude or the outputs
  of runs of scripts created by Claude.

* Session log files are available in `notes`, with the current
  session's log directly under `notes` and older session logs under
  `archive`. Log numbering is off by one, so part 3's log is
  `session-log-2.md`, and part 2's log is `session-log.md`. For part
  1, there is a somewhat similar `run_logs.txt`.

* Full transcripts of the conversations may be made available
  eventually (technical limitations may prevent some conversations
  from being shared in full, and full chains of thought may not be
  available in the transcripts).

## Vipul Naik's research process

### Initial conversation with Fable on 2026-07-22

The project started through a chat session between Vipul Naik and
Claude Fable 5, where I asked Claude to look at BBKN and come up with
a good abstraction, then push the number theory as far as possible.

The broader context for this was that this was shortly after the
negative resolution of both the Jacobian conjecture ([Levent Alpoge
tweet](https://x.com/__alpoge__/status/2079028340955197566)) and the
Dinitz-Garg-Goemans conjecture ([ChatGPT
session](https://chatgpt.com/share/6a60b2eb-0b64-83ee-9c76-7931ca1de063),
[Dmitry Rybin
tweet](https://x.com/dmitryrybin1/status/2079904005652893709)). I was
curious how easy it is to make progress on a *particular*
conjecture. About 15 years ago, I had collaborated on [Evasiveness and
the Distribution of Prime Numbers](https://arxiv.org/abs/1001.4829)
(that we'll call BBKN for the initials of the authors' last names), a
beautiful partial result related to the Aanderaa-Rosenberg-Karp
conjecture (ARK conjecture). The ARK conjecture asserts evasiveness of
all nontrivial monotone graph properties; our results showed that
additive number theory statements like Vinogradov's theorem on the
Goldbach conjecture can help establish evasiveness of sparse graph
properties.

I had a general intuition, going into the chat, of the direction I
wanted to take: I wanted to push the limits of the number theory and
figure out how far variants of the approach taken in BBKN would go.

Here are my first few prompts along with select samples from Fable's
reply.

#### First turn

My message:

> https://arxiv.org/pdf/1001.4829 uses number theory and a few results
> proven earlier to find permutation group actions on n vertices where
> the minimum orbital sizes are large, to prove that monotone graph
> properties of sparse graphs (up to some maximum number of edges) are
> evasive. Abstract out a general statement from this in terms of a
> permutation group search problem, and then determine what the limits
> of this approach are.

Key snippet from Fable's reply:

> Problem (minimum u-orbital maximization under Oliver's condition). Define

> μ(n) = max { m*(Γ) : Γ ≤ Sym([n]), Γ satisfies Oliver's condition },

> where m*(Γ) is the minimum size of an orbit of Γ acting on the 2-subsets of [n]. Then:

> Meta-theorem. Any nontrivial monotone property P with dim(P) + 1 <
> μ(n) (i.e., every graph in P has fewer than μ(n) edges) is evasive
> at n. Hence f(n)-sparse properties are eventually evasive whenever
> f(n) = o(μ(n)) along all large n.

The rest of Fable's reply talked about the different levers and their
limitations. Most of this was consistent with my own understanding, so
it was just good to get confirmation.

#### Second turn

My message:

> It's been a while but IIRC my main idea contribution to the paper
> was the idea of using the Goldbach conjecture to go beyond a purely
> multiplicative number theory into additive number theory, which is
> what allows us to go from "natural numbers with a particular
> multiplicative structure" to "all natural numbers". Are there any
> more unlocks, or is multiplication and addition the only two levers
> we have?

Key snippet from Fable's reply:

> Are these the only levers? Within the "make all u-orbitals large"
> formulation, I think essentially yes — and worse, the frontier is
> their interaction, which is where analytic number theory is
> weakest. Pushing past n^{3/2} needs primes r in a prescribed
> progression with r − 1 having a prime divisor of size r^{1/2+δ} — a
> shifted-prime problem inside a progression. Sieve methods hit the
> parity problem on exactly this kind of question, which is why
> Chowla-type statements are conjectural. So the ceiling isn't "we
> lack a third lever," it's that the second lever's fuel (Dirichlet
> primes) and the first lever's fuel (divisors of shifted primes) have
> to be pumped simultaneously, and their joint distribution is beyond
> current technology.

#### Third turn

My message:

> btw
> https://www.sciencedirect.com/science/article/pii/S0304397514004290
> ended up making the n^{5/4} unconditional to ERH. But I don't think
> it moves the needle in terms of the potential of this approach?

Key snippet from Fable's reply:

> Right — that's Shparlinski's "Evasive properties of sparse graphs
> and some linear equations in primes," which gives an unconditional
> version of the ERH-conditional result of the 2010 paper. And I agree
> with your assessment: it's needle-static, for a reason that's
> instructive about which layer of the argument each ingredient lives
> in.

#### Fourth turn (breakthrough)

My message:

> ok can we come up with a rigorous statement that says that you
> cannot systematically find a group satisfying Oliver's condition
> beyond n^{3/2} (converted to the appropriate asymptotic stuff)
> conditional on some number theory prime distribution hypotheses

Key snippet from Fable's reply; this is where it came up with the key
formulation and the rest was building out the details:

> The surprise: the ceiling conjecture is false

> Take the simplest instance: n = p + r, both prime, p ~ r ~ n/2, with
> r a safe prime (r = 2q + 1, q prime). Then Γ = (𝔽_p ⋊ C_{p−1}) ×
> (𝔽_r ⋊ C_q) satisfies Oliver's condition via 𝔽_p ◁ (𝔽_p ⋊ C_{p−1}) ×
> 𝔽_r ◁ Γ: the bottom is a p-group, the middle quotient C_{p−1} × 𝔽_r
> is cyclic (gcd(p−1, r) = 1), the top is C_q = ℤ/2... no wait, q is a
> large prime here and C_q is the top q-group — fine, q odd prime, top
> layer is a q-group of order q. Orbitals: intra-p-block ~ p²/2,
> intra-r-block ~ qr ~ r²/2, cross ~ pr. All are Θ(n²). So μ(n) =
> Θ(n²) for every n admitting such a representation — and "every large
> even n is a prime plus a safe prime, both ~n/2" is a garden-variety
> Bateman–Horn/Hardy–Littlewood-type conjecture with predicted
> representation count ~ n/log³n. (Odd n: adjust with a small third
> block.)

#### Fifth turn (articulation of where the approach lands)

My message:

> ok then can you establish an exponent bigger than 3/2 conditional to
> some believed-true number theory conjectures (of the flavor of
> "binary Goldbach-type problems with multiplicative side conditions
> on shifted primes"), and at what exponent would that approach cap
> out?

Key snippet from Fable's reply:

> Yes — and the ladder goes all the way to exponent 2, with the cap
> being a constant below the full edge count rather than an exponent
> below 2. Let me give the construction ladder, the conjectures each
> rung needs, and the terminal obstruction.

### Continued work across conversations

I continued working, mostly with Fable, in the initial conversation,
sharpening the hypothesis, then I had it write up notes that it would
keep editing. It also wrote several scripts. Eventually, I downgraded
to Opus once the key research breakthroughs were behind us and a lot
of the work was routine script tweaking and debugging.

The conversation eventually got so long that I was unable to send
further messages in it as it could not be compacted any further with
the Claude plan I had at the time. I then started a second
conversation, and was surprised to see that several errors and
omissions were caught by Claude at the start of the session. This
highlighted the importance of starting a new session periodically to
get a fresh-eyes review and avoid going down dead ends for too long. I
followed the practice, starting a new conversation once the existing
conversation had gotten long, making sure to wrap up the loose ends
within the existing conversation.

As of 2026-08-11, I was on my sixth conversation.

This does not include conversations outside the core flow, described
further down.

#### Model mix for core conversations

My core conversations mostly used Opus 5 as the workhorse. It wrote up
notes, wrote scripts, debugged things, did initial literature
searches, etc. I used Fable 5 as a cameo actor in conversations,
primarily for the hard lemmas that Opus 5 was unable to do on its own,
that I wasn't able to eyeball a solution to, and that I didn't feel
were worth me spending a lot of my own time on. In almost every case,
Fable was able to solve the lemma in a few minutes. I would then
switch back to Opus to document the proof.

#### Financial structure

My initial conversation with Fable used the free credits provided by
Anthropic (I had $120 in total); I was on the $200/year Claude Pro
subscription at the time. I blew through the credits quickly. My
subscription's limits turned out to be inadequate to the demands of
the research flow, and I ended up continuing the spend credits at a
high rate, until I decided to upgrade to the $100/month plan for a
month. After the upgrade, the work fit within the plan's usage limits
with the exception of one turn where I ended up spending about
$8. Overall, I suspect that if I had been on the $100/month plan from
the outset, my usage would have been within the plan's limits with the
exception of maybe about $20 to $30 of credit spend.

A few points of comparison:

* [Turturean's estimate of the cost of work with GPT 5.6 finding an
  explicit presentation of the 2-adic Absolute Galois
  Group](https://x.com/DavidTurturean/status/2081788611993735585) that
  says $6,000 vs $40,000 at raw API prices.

* [OpenAI's ten advances in
  mathematics](https://openai.com/index/ten-advances-in-mathematics/)
  where they estimate: "The total number of tokens needed to find
  solutions to these problems would cost roughly $2,000 at Sol API
  rates."

* [Riemann zeta function work by
  Claude](https://www.anthropic.com/research/riemann-zeta) that
  estimates the (unreleased) Claude model "using a total of 31 million
  output tokens." More: "Initially, Claude generated and tried 650
  ideas, none of which worked. Jarred prompted Claude to try again,
  and it spent a day and a half coordinating about 60 Claude
  subagents, which this time went much deeper: between them, they ran
  2,400 shell commands and wrote hundreds of Python scripts."

### LLM conversations outside the core flow

* I had several conversations with the free version of ChatGPT, and a
  few with Claude Sonnet 5, confirming and exploring my understanding
  of the additive number theory. I don't see this as direct research
  use, but rather similar to my consumption of Wikipedia pages,
  academic papers, blog posts, and videos to understand the background
  material better. The main advantage of using the LLM was that I was
  able to pose very specific questions, or confirm very specific
  observations, around nuances that my reading of the other sources
  raised, that weren't directly addressed in those other sources.

  For the most part, these conversations did not meaningfully change
  the core flow; they just sped up my intuition-building process
  around additive number theory. The one exception is that ChatGPT
  came up with the explicit idea of using density of representations,
  rather than mere existence, to provide support for the
  conjecture. I'd probably eventually have had the same idea (as a
  literature search done later did show this used in similar work) but
  it did give me the idea sooner.

* I also had some discussions with Claude Sonnet 5 on the research
  process and challenges with it, that didn't go into a lot of
  technical depth on the ARK conjecture.

* My co-author Raghav also had several LLM conversations vetting proof
  details; many of which caught important framing issues (and
  therefore reduced the number of fresh conversations I had to start
  to get to a relatively error-free set of documents).

### Document state management

I managed document state in git (in repositories synced to GitHub),
initially the [working-drafts repo's ark
folder](https://github.com/vipulnaik/working-drafts/tree/master/ark)
and later the [ark-conjecture
repo](https://github.com/vipulnaik/ark-conjecture). All conversations
were in Claude.AI UI, so the downloading and syncing to the git repo
was done manually by me. I didn't use a Claude.AI project or Claude
Code for this, so I was responsible for the document state management
as well as checkpointing progress in git commits. This meant I could
do additional sanity checks before committing changes, including
verifying that the diffs were not of an unusual size or shape. Beyond
these sanity checks, I didn't read every diff carefully before
committing.

At every new conversation, I therefore had to re-upload the relevant
subset of documents.

I didn't manually edit any of the documents that Claude was working
on. The general philosophy was that this would make state management
harder, and the coordination would slow things down. My plan was to
have Claude do all the actual writing and editing of documents until
everything passed muster, at which point the documents would be used
as a starting point for a human-written paper.

#### Script runs

Claude *wrote* all the scripts, and ran them on small ranges to debug
them. However, Claude has limits on how long it can run scripts, so
the longer script runs were done by me on my laptop and directly
committed to the repo (and uploaded to Claude where needed).

## Learnings about research that might transfer to other research contexts

### The importance of fresh sessions, plus the template used to kickstart sessions

Starting new sessions periodically, with the documents re-uploaded and
with a request for a fresh review, was very helpful for catching
mistakes and identifying new directions. The reads across fresh
sessions were close enough to independent, despite working within a
Claude account with shared memory, because the memory isn't detailed
enough.

I used Opus for the fresh review for some of the earlier iterations,
but used Fable for the fresh review once the basic mistakes were
caught.

Here is the fresh review message template, tweaked a little bit based
on where in the research process we were.

[BEGIN MESSAGE]

[Starting off with Fable to make progress on open problems more decisively]

Starting a new chat on a topic that we've had two other long chats
about, so that we can start off with fresh eyes.

I've been working (with you in other chats) on making progress on >
the Aanderaa-Rosenberg-Karp conjecture, building on >
https://arxiv.org/abs/1001.4829 that connects evasiveness on sparse >
graphs to additive number theory. I'm not attaching all the >
documents we worked on, just a relevant subset. Will share more as >
needed. Here is what

I'd like you to do the following; if you run out of per-turn budget, >
share what you have so far and I'll review and then (likely) ask you >
to continue.

1. Start with orbital-evasiveness-notes.md. Focus on the introductions
  and sections 1 to 6 with a critical eye (more on what this means
  below). Skim sections 7 onward but don't expend a lot of resources
  of careful critical reading of it except any parts that speak to the
  earlier sections.

2. Read enumeration-proof.md and arithmetic-of-density.md with the
  same critical eye; a lot of it complements
  orbital-evasiveness-notes.md.

3. If you have time after that, read small-degree-computation.md and
  three-uniform-note.md, two documents that cover complementary
  nuances and extensions, and help cross-check the material.

4. Read pending-checks.md and literature-findings.md after you are
  done, and compare your notes on things you flagged as worth
  checking/improving against what pending-checks.md covered.

5. I've attached a few key scripts and their outputs that might be
  particularly relevant for you to double-check. If you see mentions
  of other scripts that you want to cross-check (either things
  mentioned by name directly or cases where there implicitly seems to
  be a script used to generate the data) ask me for them, and use your
  turn to address other aspects of the work rather than trying to
  rebuild the script from scratch just because it wasn't made
  available (rebuilding from scratch specifically for independent
  validation is okay).

What a critical eye means:

* Focus first and foremost on whether the statements and reasoning
  seem correct in spirit, and whether they agree with or violate your
  heuristics reading them cold.

* Secondarily, focus on whether they are correct in letter, paying
  particular attention to errors that could affect the semantic
  interpretation and secondarily on typos.

* Do not focus on how the wording can be improved or how section
  structure can be improved; if a suggestion pops up in your mind,
  that's fine, but the goal right now is not figuring out the best way
  to organize the findings.

Note that script output mu_table_safe_v4.csv is from a partial run of
the latest, fixed code mu_enumerate_v2.py. mu_table_safe_v2.csv is
from an earlier version mu_enumerate.py that had a bug causing it to
miss some configurations (e.g., for 308).

We want to eventually switch gears to working on the open parts, but
first I want a critical pass of what's there, so we have more
confidence in what we're building on.

[END MESSAGE]

### The fundamental changing-truth challenge in research that doesn't exist in coding

When maintaining a set of working documents describing the current
picture of research, there was a significant challenge involved in
keeping the documents up-to-date and reflective of the current
understanding. The challenge was centrally that portions of the
document written may have been correct based on the understanding of
the time, but are now no longer correct, yet finding all such
instances and correcting them is tedious and error-prone.

This is less of an issue with coding, because of the modular nature,
the compilation/testing framework, and the fact that coding describes
a system state rather than a current understanding of an ambient truth
about the world.

Claude did come up with a script to check the documents for
consistency and correctness (available
[here](../scripts/check_doc_figures.py)).

Even though LLMs are worse at maintaining global state in their head
than humans (see next subsection) I feel like this changing-state
nature is actually an advantage for the LLMs because it's easier for
them to quickly do a full pass (helped by human guidance on what to
check, as well as scripts written by them). This makes the LLMs very
helpful in early iterations of a research effort where the goal isn't
to write something super-clearly but just to figure out what is true.

### The relative strengths of the human and LLMs

#### My human role and its strengths

Through the research process, one of my strengths was a better
big-picture view. Here's how I'd describe it semi-concretely, without
going into too many problem-specific details:

* I was able to eyeball-skim large documents and catch presentational
  inconsistencies better than Opus (maybe not better than Fable, but
  Fable is generally to slow to use for the faster editing
  iterations). This human "eyeballing" edge becomes relevant as soon
  as the document becomes long enough that the whole document isn't
  stored in the LLM's context; the LLM needs to run grep commands to
  "re-read" the document.

* I often had better intuition than Opus (and even Fable, in many
  cases) about whether a statement was plausibly true, even without
  working through the entire proof myself, so I often caught Opus when
  it was making an assertion whose local logic I wasn't immediately
  able to find mistakes in but that I felt couldn't be true.

  A few examples from the session log of part 5 of the conversation
  (note that the session log numbers are off-by-one since we started
  keeping session logs only with part 2, so these point to
  `session-log-4.md`; part 1 had `run_logs.txt`):

  * [Incorrect Frobenius
    claim](https://github.com/vipulnaik/ark-conjecture/blob/master/notes/archive/session-log-4.md#twenty-fifth-batch-the-frobenius-claim-was-wrong-and-c--32-is-why)
    that I caught immediately because I had the intuition that the
    reasoning given (about the consruction not being possible) was
    based on incorrect generalization, and that we had to have enough
    space for the construction to be possible.

  * [Counterexample of
    133](https://github.com/vipulnaik/ark-conjecture/blob/master/notes/archive/session-log-4.md#forty-first-batch-the-n--133-worked-example),
    again to an incorrect claim by Opus that there wasn't enough space
    to construct a certain kind of counterexample.

  * [Observation that the shifted-prime condition disappearance
    intuition and calculations by Opus was
    incorrect](https://github.com/vipulnaik/ark-conjecture/blob/master/notes/archive/session-log-4.md#thirty-sixth-batch-the-shifted-prime-condition-survives-at-k--3-and-the-census-measurements-were-invalid)

* I also had a better sense of the form "this kind of statement should
  be provable because it should boil down just to a case enumeration"
  in cases where Opus (and even Fable, sometimes) would just throw up
  its hands. This was particularly important in closing the
  proof. Once I explained my intuition about provability, Opus was
  able to execute on most of the details, and Fable was able to prove
  or disprove the difficult lemmas.

  * For instance, early on, I had the sense that the group theory
    content (currently living in
    [enumeration-proof.md](../notes/enumeration-proof.md)) should be
    able to reduce the group theory to some kind of combinatorial
    search of arithmetic configurations, and that the reduction should
    be two-way, i.e., there should be a correspondence between
    arithmetic configurations (partitions with divisibility
    constraints) and the kinds of groups we were looking for. While
    establishing all details required work, my intuition that this
    should just be a matter of working through the cases was important
    because the default LLM tendency was just to throw up its hands
    and not push hard on this.

  * I had a similar sense within the arithmetic part of the problem:
    that it should be possible to translate the problem into a bunch
    of cases based on the residue (congruence class) for a modulus and
    work out all the cases, and when there were two different
    optimization problems that had moduli of 8 and 12 respectively,
    using a modulus of 24 would allow these to be combined into one
    giant table.

* I often had better presentational ideas (that were important not
  just presentationally but because the presentation of one step would
  be the informational input to the other), such as: this stuff would
  be much easier to understand if it were presented in table form,
  adding these columns to the table would help, abstracting things out
  in this way would make it easier to follow, working out the fuller
  details here would help. Opus and Fable would spontaneously make
  tables some of the time, but often they would wallow in proof
  details that had gotten past the point of comprehensibility, where a
  table immediately clarified the situation. I think this is related
  to the eyeball-skim point.

* I was also able to come up with good high-level generalization
  moves, such as "let's look at 3-uniform hypergraphs instead of just
  graphs" or "let's see what happens if we replace Oliver's condition
  with solvable groups" that helped identify which hypothesis is
  important here, and helped give higher-level earned confidence in
  the shape of the results.

#### The Fable/Opus differential

This has already been touched on, but it's worth a bit more detail.

* Fable was clearly substantially better at proving or disproving hard
  lemmas; it was able to apply its greater intelligence to persisting
  enough to find an example. Other than the initial breakthrough, I
  don't think any of the things it did are things I wouldn't have been
  able to do, but they would have taken me much more wall clock
  time. Fable isn't necessarily smarter than me, but it's more like a
  slightly dumber version of me but operating at 5-10x the speed. For
  problems where persistence of exploration matters more than the
  slight intelligence differential in my favor, and where I don't have
  the domain-specific intuition that would allow me to short-circuit
  the exploration, Fable shines.

* When it came to routine document edits and state management, the
  Fable/Opus differential was small, and I preferred to use Opus both
  to save cost and to get faster turnaround. In these cases, the more
  intelligent input around direction was coming from me, and faster
  routine execution therefore used my own time more efficiently.

### The LLM state management and exposition challenges (some worth addressing, some worth living with)

One thing that became clear to me was that the LLMs simply haven't
really built the skills to manage state on complex projects well. A
few things they were **bad** at (some of this overlaps with the human
strengths documented above, but there's also some genuinely new
material):

* Dehistoricization: A lot of LLM edits would keep historical
  references to earlier versions of the document, and I ended up
  ultimately giving standing instructions to dehistoricize, removing
  historical references, reframing as gotchas where valuable, and
  using a session log file to keep notes of what it did. Even with
  that guidance, historical references would continue to survive.

  This is worth fighting; it's hard to fully get the LLMs to overcome
  their tendency to accumulate historical references, so it's
  important to keep reminding them to do a dehistoricization
  pass. It's also important to eyeball-skim enough to make sure that
  stuff is staying dehistoricized.

  The reason this needs to be fought is that without
  dehistoricization, the documents get really unwieldy, and this
  affects both human reader and LLMs, particularly the LLMs doing
  fresh-eyes review. In addition to historical references being
  directly confusing for readers who are not cued in to the history, a
  non-dehistoricized document often tends to just be way longer.

* Coming up with compact representations such as tables: My biggest
  contributions were often telling the LLM to make flowcharts and
  tables to compactly represent ideas that had grown unwieldy across
  long paragraphs of text.

  This is worth fighting; my role as a human was often to suggest the
  right compact representation. This both helped me as a human
  understand the progress better, and helped the LLM catch its own
  mistakes (through the table's forced parallel structure and "what
  should go in the cell?" question). I also expect that it made it
  easier for each fresh session to read the material and get a clearer
  understanding of it, building a better compact internal
  representation.

  It's worth noting also that LLMs do often spontaneously come up with
  tables to explain their ideas in chats, and sometimes also put them
  in documents. However, this is more like "here's a table to express
  my stream-of-consciousness thoughts" rather than "here's a table
  structure that is expected to be good at revealing the underlying
  structure, compactifying the internal representation through the
  implicit parallel structure forced by tables, and catching
  inconsistencies or missed cases" and it was the latter that the LLMs
  were missing.

* Cringe writing style: The writing style has this weird mix of being
  both formal and casual, with an extraordinary poetic density;
  "sophomoric" is the term.

  This was the part I decided was *not* worth fighting for the
  research phase. The writing style is cringe, but the goal is to just
  write clearly enough for the human and LLM to follow, and to create
  something that can be used as an input for a human-written
  paper. Optimizing on writing style doesn't instrumentally benefit
  the research pipeline itself over short time horizons, and it would
  involve a lot of work getting the LLM to overcome its tendencies, or
  it would require significant human input, that is better spent
  advancing the research.

  The solution was just to accept that the writing style will be
  cringe, and that, once all the details have been worked out, it
  might need a start-to-finish human rewrite. The goal was still to
  get everything worked out as clearly as possible that the human
  rewrite would purely be about fixing tone and sequencing rather than
  require figuring things out on the spot, so it could be done in a
  flow state without the constant interruption of having to work out
  details.
