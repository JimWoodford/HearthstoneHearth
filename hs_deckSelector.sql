ALTER PROCEDURE "dba"."hs_DeckSelector"( out "webTable" long varchar ) 
result( "html_document" long varchar ) 
begin
  declare "res" long varchar;
  --------------------------------------------
  --get decks
  select "d"."id" as "deckId","d"."Hero" as "Hero","d"."deckString" as "Deck",
    "d"."heroPower" as "Power","d"."SignatureTreasure" as "Treasure", d.patch
    into #Decks
    from "DuelsDecks" as "d"  order by "d"."id" asc;
  --------------------------------------------
  set "res" = '<div class="col p-3 bg-primary text-white">';
  set "res" = "res" || '<h2> Available decks </h2>';
  --------------------------------------------
  set "res" = "res" || '<table width="100%" border=3 align=center>';
  set "res" = "res"
     || '<tr>'
     || '<th>Deck Id</th>'
     || '<th>Hero</th>'
     || '<th>Deck</th>'
     || '<th>Power</th>'
     || '<th>Treasure</th>'
     || '<th></th>'
     || '</tr>'
     || (select "list"('<tr align=left>'
       || '<td>' || "d"."deckId" || '</td>'
       || '<td>' || "d"."Hero" || '</td>'
       || '<td><input id="Code1" type="text" value="' || "d"."Deck" || '" /></td>'
      --|| '<td><button class="btn" data-clipboard-target="#Code1"> Copy Deck Code </button></td>'
       || '<td>' || "d"."Power" || '</td>'
       || '<td>' || "d"."Treasure" || '</td>'
       || '<td>' || "d"."Patch" || '</td>'
       || '&nbsp;</td>',
      '' order by "d"."Hero" asc) from #Decks as "d" where d.patch is null )
     || '</table>';
  set "res" = "res" || '</div>';
  set "webTable" = "res"
end