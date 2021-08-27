VAR KnowOfMagician = false
VAR BoredOfMusic = false

== listen_music
    You listen to {&some Mozart|Toxic by Britney Spears|some Coltrane}
    {WitchSecrets == 4 and RANDOM(1, 3) == 1 and not KnowRecipe:
        Suddenly, the phone rings : this the magician calling.
        ~ KnowOfMagician = true
    }
    {listen_music > 10:
        You get so bored of music.
        ~ BoredOfMusic = true
    }
    ->->