VAR AvailableStorylets = ()
VAR all_storylets = ()
VAR st_diverter = ->default_diverter
VAR st_conditioner = ->default_conditioner
VAR st_verbose = ->default_verbose

== initStorylets(list, -> conditioner, -> verbose, ->diverter)

~ all_storylets = LIST_ALL(list)
~ st_conditioner = conditioner
~ st_diverter = diverter
~ st_verbose = verbose

~ compute_available(all_storylets, LIST_COUNT(all_storylets)) //initial computation
->->

== function compute_available(list, max)
~ temp current = LIST_MIN(list)
~ temp current_is_available = st_conditioner(current)

{ list == all_storylets:
    ~ AvailableStorylets = ()
}

{ LIST_COUNT(list) > 0 and max > 0 :
    {current_is_available:
        ~ AvailableStorylets += current
        ~ compute_available(list - current, max - 1)
     -else:
        ~ compute_available(list - current, max)
    }
    
}

== default_diverter(st)
    ->END

== function default_conditioner(st)
    ~ return true

== function default_verbose(st)
    ~ return "{st}"

== listAvailableStorylets(max)
~ compute_available(all_storylets, max)
<- threadAvailable(AvailableStorylets, max)
-> DONE

=== threadAvailable(list, max)===
    ~ temp current = LIST_MAX(list)
    
    { LIST_COUNT(list) > 0 and max > 0:
        <- threadAvailable(list - current, max - 1)
        + [{st_verbose(current)}]
            ->st_diverter(current)
    } 