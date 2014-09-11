select COUNT(*) FROM 
(SELECT 
b.member_no, b.firstname, b.lastname, e.region_name, e.region_no,
d.provider_name, a.category_desc,
c.charge_no,c.category_no,c.charge_amt, c.charge_dt
 from 
category a,
customer b,
Transactions c, 
provider d,
region e
where 
b.member_no = c.member_no and
b.region_no = e.region_no and
a.category_no = c.category_no) CC;

select count(*) from (
select 
b.member_no, b.firstname, b.lastname, e.region_name, e.region_no,
d.provider_name, a.category_desc,
c.charge_no,c.category_no,c.charge_amt, c.charge_dt
 from 
Transactions c  
inner join category a on c.category_no = a.category_no
inner join customer b on c.member_no = b.member_no
inner join provider d on c.provider_no = d.provider_no
inner join region e on e.region_no = b.region_no
) aa