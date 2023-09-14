2023-09-14 0.13.8 Index pagination properly.
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

* Add interests to the story template in a smart way.
* Add TranslatedStory in English as a delayed task upon completion of creation of a story. Sth like *after_save*
* Add seamless login. Many things depend on user_id and should be made mandatory..

From TODOs on Mac at home:

* both done
