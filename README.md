# Native Storylet framework for Inkle's ink

## Requirements 

* Good grasp of the ink scripting language
* Knowledge of [tunnels](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md#1-tunnels)
* Basic knowledge of [threads](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md#2-threads)

This framework does not rely on any external function and will function natively in any player.

[Try a demo on itch.io](https://smwhr.itch.io/ink-storylets)

## How to use

Import the `include/storylet.ink` file and add the import in your main file
```
INCLUDE include/storylet.ink

```

This file provide the basic functionalities to handle the storylets.  

The framework relies on 1 LIST and 3 functions (actually 1 knot and 2 functions) :  
(see `include/database.ink` for a complete example)

### the LIST

This would be the LIST of all storylets.

For example :
```
LIST Storylets = st_magician, // story at the top has more priority
                 st_witch, 
                 st_kitchen, 
                 st_music // story at the bottom has less priority

```

The stories that are listed first have more priority and will be evaluated and displayed first.

### the conditioning function

This function will be called on each item of the storylet list and must return `true` or `false` if the storylet is available or not. This works really well with a [Knowledge System](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md#7-long-example-crime-scene)

#### Example :
```
== function conditions(storylet)
{storylet: 
	- st_magician: ~ return KnowOfMagician and not meet_magician
	- st_witch: ~ return KnowOfWitch and WitchNotAngry
	- st_kitchen: ~ return VeryHungry and HasRecipe
	- st_music: ~ return HasRecord
	- else: false
}

```

### the diverting knot

This knot will be the chef d'orchestre of the storylets. It will be called upon a storylet choice. For a given storylet, it must trigger a tunnel to the actual story code. 

#### Example :
```
== goto(storylet)
	You enter the Twilight Zone.
    {storylet:
        - st_magician: 
            -> meet_magician ->
        - st_witch: 
            -> meet_witch ->
        - st_kitchen: 
            -> cook_kitchen ->
        - st_music:
            -> listen_music ->
    }
    -
    End of the mini-adventure !
    ->lobby

```

The system is flexible enough that you can either call a simple tunnel, a chain of tunnels, knot with parameters, add extra conditions etc.

### the verbose function

This function will be called on item of the storylet list that will be displayed. For each item, it must return a string that will be the actual text of the choice.

#### Example :
```
== function choice_text(storylet)
    {storylet:
        - st_magician: The magician is waiting
        - st_witch: The witch summoned you {|again}
        - st_kitchen: You run to the kitchen
        - st_music: Wait and listen to some music
    }
```

Here, again, the system is flexible enough to be tweaked and use all the tools the ink language provide. 
** limitation ** : choice text is always wrapped inside `[]` and thus will not be printed.

When used with an external system, if the storylet choices are not displayed as traditional choices, this is a good place to add additional formatting for the engine.

#### Example :
```
== function choice_text(storylet)
    {storylet:
        - st_magician: The magician is waiting
        - st_witch: The witch summoned you {|again}
        - st_kitchen: You feel hungry
        - st_music: Wait and listen to some music
    }
```

### and now what ?

Now that we have our list (`Storylets`) and 3 functions (`conditions`,`choice_text` and `goto`), we can initialize the system using the `initStorylets` tunnel.

```

-> initStorylets(Storylets, ->conditions, ->choice_text, ->goto) ->

```

Once this is done, whenever you need to display the list of storylets, you can thread the helper function `listAvailableStorylets`

#### Example :

```
You are back to your room.
~ temp maxDisplay = 3
<- listAvailableStorylets(maxDisplay ) // will evaluate storylets by order of priority
									   // until it has found maxDisplay available stories
* ->

```

_Remember to alway leave an empty default choice after a thread if you have no other option ! Otherwise the thread won't be displayed correctly_

If you expect the thread to dry up, especially when you are in a loop, use `CHOICE_COUNT` to provide an explicit default option.

#### Example 1 : providing a choice if none exist

```
<- listAvailableStorylets(3)
* {CHOICE_COUNT() == 0} Nothing to do anymore ...
     They lived happily ever after.
     -> END

```

#### Example 2 : getting out of the loop

```
== story_hub

You are back to the hub.

<- listAvailableStorylets(3)
* ->

{CHOICE_COUNT() == 0:
    -> elsewhere
}

-> story_hub

== elsewhere

They lived happily ever after.

```

## Full implementation

The `Castle.ink` in this repository is the entrypoint of a complete implementation.