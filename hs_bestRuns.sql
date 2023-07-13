ALTER PROCEDURE "dba"."hs_BestRuns"( out "webTable" long varchar ) 
result( "html_document" long varchar ) 
begin
  declare "res" long varchar; --html output
  -- fetch filters
  declare @account varchar(40) = 
  (select "filtervalue" from "hs_filters" where "filterName" = 'Account');
  declare @accountName varchar(40) = 
  "coalesce"((select "Name" from "hs_accounts" where "id" = @account),'All');
  --query for data to put on page
  select top 10
    "Rank"() over(order by "g"."gamesWon" desc) as "Rank",
    "g"."id","d"."hero","g"."gameNote","g"."gamesWon"
    into #topten
    from "DuelsGames" as "g"
      join "DuelsDecks" as "d" on "d"."id" = "g"."DuelsDeck_ID"
    where("g"."account" = "ifnull"(@account,"g"."account",@account))
    order by "g"."GamesWon" desc,"g"."GameNote" desc;
  --build the page
  set "res" = '<div class="col p-3 bg-dark text-white">';
  set "res" = "res" || '<h2> Best Game Runs - ' || @accountName || '</h2>';
  set "res" = "res"
     || '<table width="100%" border=1 align=center>\x0A'
     || '<tr align =center>\x0A'
     || ' <th>Pos</td>\x0A'
     || ' <th>Game Id</td>\x0A'
     || ' <th>Hero</td>\x0A'
     || ' <th>Legs</td>\x0A'
     || ' <th>Total Wins</td>\x0A'
     || '</tr>\x0A'
     || (select top 10 "list"('<tr align=center valign=top><td>' || "html_encode"("t"."Rank")
     || '</td><td><a href="showGame?action=show&id=' || "t"."id"
     || '">' || "t"."id" || '</a>'
     || '</td><td>' || "html_encode"("t"."Hero")
     || '</td><td>' || "html_encode"("t"."GameNote")
     || '</td><td>' || "html_encode"("t"."GamesWon")
     || '&nbsp;</td>',
     '' order by "t"."GamesWon" desc,"t"."GameNote" desc)
     from #topTen as "t")
     || '</table>';
  set "res" = "res" || '</div>';
  set "webTable" = "res"
end