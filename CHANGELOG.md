2024-01-27 0.14.9  Actually INSTALLING HTMX
2024-01-27 0.14.8  Trying to add HTMX. But first, fixing APIs which dont work. Adding
2023-10-01 0.14.7  now that APIs are fixed, I went on and fixed a few things. Added upload size, customized
                index with a couple of numbers.
2023-10-01 0.14.6  Nothing major, I just found the JSON key has expired and Im loading a new one. Nothing
                   you'll see by yourselves :) Old one: `487a5d`..
2023-10-01 0.14.5  [Mallorca plane 1st class] Nothing really here. I debugged b/2 and it seem,
                   it has nothing to do with code.
                   Also added , multipart: true to ALL _forms. Just because it fixes the upload and shouldnt have drawbacks.
2023-09-19 0.14.4d No real change but since its broken in prod, Im trying to fix the ENV vars.
2023-09-19 0.14.4  Adding images and docs under `doc/`
2023-09-19 0.14.3  Prioritizing TS with 100% images and audio in UI.
2023-09-19 0.14.2  UI cleanup pre demo
2023-09-14 0.14.1  Adding `cached_completion` to TS so i can query via SQL.
2023-09-14 0.13.10 Fixed StoryParagraphs to also default to 200 so now they align to TS :)
2023-09-14 0.13.09 Added `completion_pct`
2023-09-14 0.13.08 Index pagination properly.
2023-09-14 0.13.07 Fix TODO Not primogenito copy instead adding force: true. Also fixing TranslatedTitle to TS.
2023-09-13 0.13.06 Images on Stories are now destroyable..
2023-09-13 0.13.05 patching finally the INTERESTS and making the Txt AI call smarter. Various fixes.
2023-09-13 0.13.04 bugfix, moved story score from 0..100 to -100..100 (so now default=0 has becom from shit to average joe)
2023-09-13 0.13.03 Fixing bugs after this big change. Now a new story triggers queued creation of English :) so English is a
                   litmus test for bkg jobs working :)
2023-09-13 0.13.02 Adding EN as possible translation. And adding a simple function to translate to 'en' :)
2023-09-11 0.13.01 Added interests to Kid (which has broken export to db/schema i found out!) on vacation to EuropaPark :)
2023-09-09 0.12.03 Refactored pagination to also serve TranslatedStories
2023-09-09 0.12.03 Added story pagination and found great OLD stories!
2023-09-08 0.12.02 Fixed default in EDIT TS!! Woohoo!
2023-09-08 0.12.01 Storing Score and Settings for TS and Story
2023-09-07 0.11.49 some bugfix, not important.
2023-09-07 0.11.48 Fixing the DelayedJob part. Also adding debug to the Primogenito code which is buggy
2023-09-07 0.11.48 Added Hindi language
2023-09-07 0.11.47 Fixed some audio stuff (like adding the lib properly!). Gaelic still broken (not supported by TTS API).
2023-09-06 0.11.45 Added also a miniplayer to translated StoryParagraphs!
2023-09-06 0.11.45 Adding support for mp3!!
2023-09-05 0.11.42 Lot of UI tweaks and enhancements for the demo.
2023-09-05 0.11.41 Small changes to deployment scripts and ENTRYPOINT. Wish me luck.
2023-09-05 0.11.40 Added `netcat` to Dockerfile, added Gaelic to languages for the demo
                   working towards working bkg jobs in the Cloud!
2023-09-05 0.11.39 moved text-bison@001 to text-bison without any AT :)
2023-09-05 0.11.38 Fixed dev/prod part from BIN to RB!
2023-07-08 0.11.13 TranslatedStory is now bootstrap/cute
2023-07-08 0.11.8 Installing Bootstrap for Rails7.

# BUGS

P1 | 20230901 | Now the system expects to find /sa.json also locally -> wrong!!!
P2 | 20230913 | I observed a lot of images are repeated, I believe there's a bug in the "CopyFromPrimogenito". Probably we should just remove it and attach it to the newly created ENGLISH and have primogenito to always be EN, and any susequent creation to just attach EN existing or if not exists trigger its creation  ON THE English cousin.

# TODOs

* P1 Remove the `_DANGEROUS_SA_JSON_VALUE` as useless from Cloud run. Roberto: *if you call gcloud auth print-access-token from inside cloud run it should just return a token, without login in first. because gcloud detects it's on a "managed compute"  and fetches the token from the metadata service.*
* P2 Add search for "Dr Who"
* Add interests to the story template in a smart way.
* [DONE] Add TranslatedStory in English as a delayed task upon completion of creation of a story. Sth like *after_save*
* Add seamless login. Many things depend on user_id and should be made mandatory..
    * Also add 5 creation credits per user.
* Make it easy to KILL a story. Deleting in cascade: all TS (easy), all SP (less easy), all images (even harder). Note this doesnt work: `Story.find(XXX).translated_stories.each {|x| x.delete }`.

# Bugs

* 2023-09-27 v0.11.44 b/2 [OPEN] Images and audios are unreadable.
* 2023-09-DD v0.11.41 b/1 [FIXED] Cloud Build failed.
