
  select member_no, firstname + middleinitial + lastname, issue_dt
from customer
where firstname + ' ' + lastname = 'Naresh Jain';



  select member_no, firstname + middleinitial + lastname, issue_dt
from customer
where firstname  = 'Naresh'
and lastname= 'Jain';
