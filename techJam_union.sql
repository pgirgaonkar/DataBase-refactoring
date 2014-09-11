select * from Transactions where charge_amt = 95;


select * from tx where charge_amt = 95;


select * from Transactions where charge_amt = 95
union
select * from tx where charge_amt = 95;


IF OBJECT_ID('tx1', 'U') IS NOT NULL drop table  tx1;

select * into tx1 from Transactions where charge_amt = 95;
update tx1 set charge_code = 'TE';


select * from Transactions where charge_amt = 95
union
select * from tx1 where charge_amt = 95;

select * from Transactions where charge_amt = 95
union ALL
select * from tx where charge_amt = 95;

