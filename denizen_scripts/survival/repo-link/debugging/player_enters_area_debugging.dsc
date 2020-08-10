player_enters_area_debugging:
    type: task
    definitions: area|cause|to|from|cancelled|event_header|event_name|script|queue
    wrapper:
        - define Context <list>
        - foreach area|cause|to|from|cancelled|event_header|event_name as:Tag:
            - define Context <[Context].include_single[<element[<&lt>context.<[Tag]>||<&c>Invalid<&gt>].parsed||<&c>Invalid>]>
        - ~Run player_enters_area_debugging def:<[Context].include[<queue.script>|<queue>]>
    script:
        - if <player.has_permission[override]>:
            - flag server player_enters_area_debugging:++ duration:1s
            - define Context "<list.include_single[<&b>You are seeing this because of your <&3>*<&b> Permission Node.]>"
            - define Context "<[Context].include_single[<&e>Single Second Fire Rate<&6>: <&b><server.flag[player_enters_area_debugging]>]>"
            - foreach area|cause|to|from|cancelled|event_header|event_name as:Tag:
                - define Context "<[Context].include_single[<&6><&lt><&e>context<&6>.<&e><[Tag]><&6><&gt> <&b>| <[<[Tag]>]||<&c>Invalid>]>"
            - define Context <[Context].include[<[Script]>|<[Queue]>]>
            - define Hover <[Context].separated_by[<&nl>]>
            - define Text "<&2>[<&a>Event Fired<&2>]<&b> Hover for Debug Content<&3>."
            - narrate <proc[MsgHover].context[<[Hover]>|<[Text]>]>

player_enters_area_error_handler:
    type: world
    events:
        on script generates error:
            - if <context.script.name> == player_enters_area_debugging:
                - determine cancelled
        on server generates exception:
            - if <context.script.name> == player_enters_area_debugging:
                - determine cancelled