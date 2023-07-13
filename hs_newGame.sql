ALTER PROCEDURE "dba"."hs_newGame"(in account integer, deck integer, FullDeck varchar(3)) 
result( html_document long varchar ) 
begin
    declare FD integer;
    declare res long varchar;
    declare @header     long varchar = (select html from hs_webPages where pageTitle = 'Hearth_Header');
    declare @mainBar    long varchar = (select html from hs_webPages where pageTitle = 'Hearth_MainBar');
    declare @footer     long varchar = (select html from hs_webPages where pageTitle = 'Hearth_Footer');
    
    case when
        FullDeck = 'yes' then set FD = 1
    else set FD = 0
    end;
 
    set res = @header;
    set res = res || @mainBar;
    set res = res || '<div class="container-fluid mt-2">';
    set res = res || '<div class="row">';
    set res = res || '<div class="col-sm-6">';
    set res = res || '<a href="root?action=welcome" class="btn btn-outline-primary">OK</a>';
    set res = res || '</div>';    
    set res = res || '</div>';
    set res  =res || @footer;
    
    call DuelsGame_Insert(deck,FD,account);
    call "dbo"."sa_set_http_header"('Content-Type','text/html');
select res
end