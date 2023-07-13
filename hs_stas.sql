ALTER PROCEDURE "dba"."hs_Stats"( out webTable long varchar ) 
result( html_document long varchar ) 
begin
    declare res long varchar;
    declare @gameId integer = 
        (select filterValue from hs_filters where filterName = 'GameId');
    declare @deckid integer = 
        (select DuelsDeck_ID from DuelsGames where id = @gameId);
    declare @account varchar(40) = 
        (select filtervalue from hs_filters where filterName = 'Account');
    declare @accountName varchar(40) = 
        (select name from hs_Accounts where id = @account);
    declare @legs varchar(20) = 
        (select gameNote from DuelsGames where id = @gameId);
    declare @Hero varchar(50) = 
        (select Hero from DuelsDecks where id = @deckid);
    declare @FullDeck varchar(3) = 
        if(select FullDeck from DuelsGames where id = @gameId) = 1 then 'Y' else 'N' endif;
    declare @gameAccount varchar(40) = 
        (select name from hs_Accounts where id
            = (select Account from DuelsGames where id = @gameId));
    declare @MMR integer = 
        (select MMR from DuelsDecks where id = @deckId);
  -----------------------------------------------------------------------------
    select g.id, a.name, g.GameNote,g.GamesWon
        into #Runs
    from DuelsGames as g
        join hs_Accounts as a on g.account = a.id        where g.DuelsDeck_ID = @DeckId
        order by g.id asc;
  -----------------------------------------------------------------------------
    set res = '<div class="col p-3 bg-primary text-white">';
    --Account
    set res = res || '<h2 align=center>Current/Last Game</h2>';
    --Current/Last game
    set res = res || '<table width="100%" border=1 align=center>';
    set res = res || '<tr align =center>';
    set res = res || '<th>GameId</th>';
    set res = res || '<th>Hero</th>';
    set res = res || '<th>Full  Hand</th>';
    set res = res || '<th>Account</th>';
    set res = res || '</tr>';
    set res = res || '<tr align=center>';
    set res = res || '<td>' || @gameId || '</td>';
    set res = res || '<td>' || @Hero || '</td>';
    set res = res || '<td>' || @FullDeck || '</td>';
    set res = res || '<td>' || @gameAccount || '</td>';
    set res = res || '</tr>';
    set res = res || '</table>';
    set res = res || '<tr>';
    --Leg Results (of current/last game
    set res = res || '<table width="100%" border=1 align=center>';
    set res = res || '<tr><td>';
    set res = res || '<h2 align=center>' || @legs || '</h2></td>';
    set res = res || '<td><a href="root?action=win" class="btn btn-success">+Win</a></td>';
    set res = res || '<td><a href="root?action=loss" class="btn btn-danger">+Loss</a></td>';
    set res = res || '</tr></table>';
    set res = res || '<tr><td>';
    -- Table of Runs forfor this deck
    set res = res || '<h4 align=left>Runs with ' || @Hero || ' - MMR ' || @MMR || '</h4></td>';
    set res = res || '</tr></table>';
    set res = res || '<table width="100%" border=1 align=center>';
    set res = res || '<tr align =center>';
    set res = res || '<th>GameId</th>';
    set res = res || '<th>Account</th>';
    set res = res || '<th>Run</th>';
    set res = res || '<th>Wins</th>';
    set res = res || '</tr>';
    set res = res || (select list('<tr align=center><td>' || r."id" || '</td>'
        || '<td>' || r.name || '</td>'
        || '<td>' || r.GameNote || '</td>'
        || '<td>' || r.GamesWon || '</td>'
        || '</tr>',
       '' order by r.id desc) from #Runs as r);
    set res = res || '</table>';
    set res = res || '</div>';
    set webTable = res
end