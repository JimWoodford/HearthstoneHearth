ALTER PROCEDURE "dba"."hs_DeckRankings"( out "webTable" long varchar ) 
result( "html_document" long varchar ) 
begin
  declare "res" long varchar;
  declare "crlf" char(4) = '\x0D\x0A';
  declare @account varchar(40) = 
  (select "filtervalue" from "hs_filters" where "filterName" = 'Account');
  declare @accountName varchar(40) = 
  "coalesce"((select "Name" from "hs_accounts" where "id" = @account),'All');
  -- query to get table data
  select "Rank"() over(order by "sum"("g"."gamesWon")/"count"("g"."id") desc) as "Rank",
    "d"."id" as "DeckID",
    "d"."Hero" as "Hero",
    "count"("g"."id") as "Played",
    cast("sum"("g"."gamesWon")/"count"("g"."id") as decimal(3,2)) as "Average"
    into #DeckRanking
    from "DuelsGames" as "g" join "DuelsDecks" as "d" on "d"."id" = "g"."DuelsDeck_ID"
    where("g"."account" = @account or @account is null)
    group by "d"."id","d"."hero"
    order by "sum"("g"."gamesWon")/"count"("g"."id") desc,"count"("g"."id") desc;
  --http code
  set "res" = '<div class="col p-3 bg-dark text-white">';
  set "res" = "res" || '<h2> Deck Rankings - ' || @accountName || ' </h2>';
  -- results table
  set "res" = "res"
     || '<table width="100%" border=1 align=center>\x0A'
     || '<tr>\x0A'
     || ' <th>Pos</td>\x0A'
     || ' <th>Deck Id</td>\x0A'
     || ' <th>Hero</td>\x0A'
     || ' <th>Played</td>\x0A'
     || ' <th>Average</td>\x0A'
     || '</tr>\x0A'
     || (select top 10 "list"('<tr align=center valign=top><td>' || "t"."Rank"
       || '</td><td>' || "html_encode"("t"."DeckId")
       || '</td><td>' || "html_encode"("t"."Hero")
       || '</td><td>' || "html_encode"("t"."Played")
       || '</td><td>' || "html_encode"("t"."Average")
       || '&nbsp;</td>',
      '' order by "t"."Average" desc,"t"."Rank" desc)
      from #DeckRanking as "t")
     || '</table>';
  set "res" = "res" || '</div>';
  set "webTable" = "res"
end