LIST Storylets = st_magician, // story at the top has more priority
                 st_witch, 
                 st_kitchen, 
                 st_music // story at the bottom has less priority

== function conditions(storylet)
    {storylet: 
        - st_magician:
            {meet_magician:
                ~ return false // can only visit him once
             - else:
                ~ return KnowOfMagician // can visit if he called
            }
            
        - st_witch:
            {WitchSecrets <= 3:
                ~ return true // can always go
            }
            {KnowRecipe:
                ~ return false // you know everything
            }
            {meet_magician:
                ~ return true // can go if magician gave clue
            }
            ~ return false // default
        - st_kitchen:
            ~ return KnowRecipe and not cook_kitchen // you have the witch's ultimate secret and not cooked yet
        - st_music:
            ~ return not BoredOfMusic // until you are bored
        - else:
            ~ return false
    }

== goto(storylet)
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
    End of the mini-adventure.
    ->lobby

== function choice_text(storylet)
    {storylet:
        - st_magician: The magician is waiting
        - st_witch: The witch summoned you {|again}
        - st_kitchen: You feel hungry
        - st_music: Wait and listen to some music
    }