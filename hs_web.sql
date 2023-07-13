ALTER PROCEDURE "dba"."hs_web"( in action varchar(40) ) 
result( html_document long varchar ) 
begin
    declare res long varchar;
    declare crlf char(4) = '\x0D\x0A';
    declare @header     long varchar = (select html from hs_webPages where pageTitle = 'Hearth_Header');
    declare @footer     long varchar = (select html from hs_webPages where pageTitle = 'Hearth_Footer');
    declare @mainBar    long varchar = (select html from hs_webPages where pageTitle = 'Hearth_MainBar');
    declare @gameId integer = 
        (select filterValue from hs_filters where filterName = 'GameId');
    declare @BestRuns long varchar;
    declare @DeckRankings long varchar;
    declare @Stats long varchar;
    declare @DeckSelector long varchar;
    declare @filters long varchar;
    declare @accountName varchar(40);
    declare @gameOver bit = 0;
    if (select len(replace(GameNote,'W','')) from DuelsGames where id = @gameId) = 3 
        or (select len(replace(GameNote,'L','')) from DuelsGames where id = @gameId) = 12
        then
            set @gameOver = 1 
        else 
            set @gameOver = 0 
    end if;

    set action = ifnull(action,'welcome',action);
  
    update hs_filters set filterValue = -- get current or last game played
        (select max(id) from DuelsGames) where filterName = 'GameId';

    if action = 'welcome' then -- set account filter to null, shows stats from all accounts combined
        update hs_filters set filterValue = null where id = 1;
        set @accountName = 'All accounts combined'
    elseif action in ('1','2') then -- set account filter to action value
        update hs_filters set filterValue = action where id = 1;
        set @accountName = (select name from hs_accounts where id = action);

    elseif action = 'Win' and @gameOver = 0 then 
        update DuelsGames set GameNote = GameNote+'W' where id = @gameId;
        update DuelsGames set GamesWon = LEN(REPLACE(GameNote,'L','')) where id = @gameId;
    
    elseif action = 'Loss' and @gameOver = 0 then -- add a loss
            update DuelsGames set GameNote = GameNote+'L' where id = @gameid;
            update DuelsGames set GamesWon = LEN(REPLACE(GameNote,'L',''))
            where id = @gameId
    end if;


    call hs_filters(@filters);
    call hs_BestRuns(@BestRuns);
    call hs_DeckRankings(@DeckRankings);
    call hs_Stats(@Stats);
    call hs_DeckSelector(@DeckSelector);

    set res = @header;
    set res = res || @mainBar;
    set res = res || '<div class="container-fluid mt-2">';
    set res = res || @filters;
    set res = res || '<div class="container-fluid mt-2">';
    set res = res || '<div class="row">';
    set res = res || @BestRuns;
    set res = res || @Stats;
    set res = res || @DeckRankings;
    set res = res || '</div>';
    set res = res || '</div>';
    set res = res || @DeckSelector;
    set res = res || @footer;
    call dbo.sa_set_http_header('Content-Type','text/html');
    select res;
    commit work
end