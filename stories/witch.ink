VAR WitchSecrets = 0  
VAR KnowRecipe = false
== meet_witch
    You meet the witch.
    {WitchSecrets == 4:
        « You managed to come back. I will give you the ultimate secret »
        The witch gives you her ultimate secret : the recipe for chocolate cake.
        ~ KnowRecipe = true
    }
    {WitchSecrets == 3:
        The witch tells you her last secret.
        She asks you to never come back.
        ~ WitchSecrets++
        You now know {WitchSecrets} secrets.
    }
    {WitchSecrets < 3:
        The witch tells you a new secret.
        ~ WitchSecrets++
        You now know {WitchSecrets} secrets.
    }
    ->->