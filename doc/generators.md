This doc describes the generators I ran over time.
this is not in main READMe since its of interest only to the original developer (probably). And it's good for my cut and pasting :)

# Models and entities

```bash
# Generation
rails g scaffold kids name:string surname:string nick:string visual_description:string \
    is_male:boolean date_of_birth:date internal_info:text user_id:integer
rails active_storage:install
rails g migration add_avatar_to_kid  avatar:attachment

# note the integer vs reference is neaerly the same behaviour: https://stackoverflow.com/questions/7861971/generate-model-in-rails-using-user-idinteger-vs-userreferences
rails g scaffold Story title:string \
    genai_input:text genai_output:text genai_summary:text \
    internal_notes:text \
    user_id:integer kid:references \
    --force

# dont add 'cover_image:attachment'
# or      images:attachment \

rails g controller page_controller index about help

rails g scaffold StoryParagraph \
     story_index:integer \
     original_text:text \
     genai_input_for_image:text \
     internal_notes:text \
     translated_text:text \
     language:string \
     story:references \
     rating:integer

rails g scaffold --force StoryTemplate \
    short_code:string \
    description:string \
    template:text \
    internal_notes:text \
    user_id:integer

rails g scaffold  --force TranslatedStory \
    name:string \
    user:references \
    story:references \
    language:string \
    kid_id:integer:index \
    paragraph_strategy:string \
    internal_notes:text \
    genai_model:string

rails g migration addTranslatedStoryReferenceToStoryParagraph \
    translated_story:references

rails g migration addFavoriteLangugageToKid \
    favorite_language:string

rails g migration addNameToUser \
    name:string # and added internal notes too.

#Now fix once for all:
$ rails c
> StoryParagraph.all.map{|sp| sp.story_id}.uniq.each do
    Create StoryParagraph  t.c. ...
  done

rails g migration addTranslatedTitleToTranslatedStory
    translated_title:string

rails g migration addActiveToStory active:boolean

# 6163  [2023-09-11 09:01:37 +0200]
rails g migration addInterestsToKid interests:text

# 6256  [2023-09-17 12:03:31 +0200]
rails g migration addCachedCompletionToTranslatedStory cached_completion:float
```
