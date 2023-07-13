ALTER PROCEDURE "dba"."hs_filters"( out webFilter long varchar ) 
result( html_document long varchar ) 
begin
  declare @Account varchar(15) = 
  (select name from hs_accounts where id
     = (select filterValue from hs_filters where filterName = 'Account'));
  declare @FullDeck bit;
  declare @DeckCode long varchar;
  declare res long varchar;
  set res = res || '<div class=row>';
  set res = res || '<div class=col-sm-6>';
  set res = res || '<a href=root?action=welcome class=btn btn-outline-primary>All</a>';
  set res = res || '<a href=root?action=1 class=btn btn-outline-primary>JumpyWizard</a>';
  set res = res || '<a href=root?action=2 class=btn btn-outline-primary>jimboww</a>';
  set res = res || '</div>';
  set res = res || '<div class=col-sm-6>';
  set res = res || '<form action=/new_game>';
  ------------------------------------------------------------------------
  set res = res || '  <label for=account class=form-label>Select Account:</label>';
  set res = res || '  <input class=form-control list=accounts name=account id=account>';
  set res = res || '  <datalist id=accounts>';
  set res = res || (select list('<option value=' || html_encode(a.id) || '>' || a.name || '</option>') from hs_accounts as a);
  set res = res || '  </datalist>';
  ------------------------------------------------------------------------
  set res = res || '  <label for=deckId class=form-label>Select Deck:</label>';
  set res = res || '  <input class=form-control list=decks name=deck id=deck>';
  set res = res || '  <datalist id=decks>';
  set res = res || (select list('<option value=' || html_encode(d.id) || '>' || d.Hero || '</option>') from DuelsDecks as d);
  set res = res || '  </datalist>';
  set res = res || '  <div class=form-check form-switch>'; 
  set res = res || '    <input type=checkbox id =fullDeck class=form-check-input  name=fullDeck value=yes checked>';
  set res = res || '    <label class=form-check-label for=fullDeck>Full Deck</label>';
  set res = res || '  </div>';
  set res = res || '  <input type =submit value =New Game>';
  set res = res || '</form>';
  set res = res || '</div>';
  set webFilter = res
end