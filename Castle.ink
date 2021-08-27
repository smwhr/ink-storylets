INCLUDE include/storylet.ink
INCLUDE include/database.ink

INCLUDE stories/magician.ink
INCLUDE stories/witch.ink
INCLUDE stories/kitchen.ink
INCLUDE stories/music.ink

-> initStorylets(Storylets, ->conditions, ->choice_text, ->goto) ->

You enter the castle

<- listAvailableStorylets(3)
* ->

-> lobby

== lobby

You are back to your room.

<- listAvailableStorylets(3)
* {CHOICE_COUNT() == 0} Nothing to do anymore ...
    -> ever_after

{CHOICE_COUNT() == 0:
    -> ever_after
}

-> lobby

== ever_after
They lived happily ever after.
->END