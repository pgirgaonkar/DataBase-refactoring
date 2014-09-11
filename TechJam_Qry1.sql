/****** ORIGINNAL QUERY *****/

update os1 set os1.Room_Departures = oz.correctedDepartures
from
opera.stage_summary os1
join
(
	select x.occupancy_dt,x.Market_Code,x.Room_Type,x.Room_Departures+z.departures as correctedDepartures
	from
		(select os.occupancy_dt,os.Room_Departures,os.market_code,os.room_type  
			from opera.stage_summary as os
			where Data_Load_Metadata_ID IN 
				(SELECT Data_Load_Metadata_ID FROM opera.Data_Load_Metadata WHERE Incoming_File_Type_Code in ('CSAT','PSAT') AND Correlation_ID = '55df0562-050c-44b7-9b13-be5ea6109247')
			and market_code in (select distinct Analytical_Market_Code from opera.Category_Rule)
		)as x
	join 
	(
		select a.occupancy_dt,a.mkt_seg_id,b.mkt_seg_code,a.accom_type_id,c.Accom_Type_Code,a.departures from
			(select occupancy_dt,mkt_seg_id,accom_type_id,departures from dbo.Mkt_Accom_Activity
				where Occupancy_DT = 
					(select DATEADD(DAY,-PAST_DAYS,CAST(business_dt AS date)) from opera.Stage_Metadata)
			) as a
			join dbo.MSeg as b
			on  a.mkt_seg_id = b.mkt_seg_id
			join dbo.AType as c
			on a.Accom_Type_ID = c.Accom_Type_ID
		)as z
	on  x.occupancy_dt =z.occupancy_dt
	and x.market_code = z.mkt_seg_code 
	and x.room_type = z.accom_type_code 
) as oz
on os1.occupancy_dt =oz.occupancy_dt
and os1.market_code = oz.market_code 
and os1.room_type = oz.room_type ;


/**** After checking the query and assessing tables the tentative pain point lies here****/


SELECT COUNT(*) FROM 
(
select os.occupancy_dt,os.Room_Departures,os.market_code,os.room_type  
from opera.stage_summary as os
where Data_Load_Metadata_ID IN 
(SELECT Data_Load_Metadata_ID FROM opera.Data_Load_Metadata WHERE Incoming_File_Type_Code in ('CSAT','PSAT') 
AND Correlation_ID = '55df0562-050c-44b7-9b13-be5ea6109247')
and market_code in (select distinct Analytical_Market_Code from opera.Category_Rule)

) A




SELECT COUNT(*) FROM 
(
select os.occupancy_dt,os.Room_Departures,os.market_code,os.room_type  
from opera.stage_summary as os
where Data_Load_Metadata_ID IN 
(SELECT Data_Load_Metadata_ID FROM opera.Data_Load_Metadata WHERE Incoming_File_Type_Code in ('PSAT') AND Correlation_ID = '55df0562-050c-44b7-9b13-be5ea6109247')
and market_code in (select distinct Analytical_Market_Code from opera.Category_Rule
)
UNION 
 select os.occupancy_dt,os.Room_Departures,os.market_code,os.room_type  
from opera.stage_summary as os
where Data_Load_Metadata_ID IN 
(SELECT Data_Load_Metadata_ID FROM opera.Data_Load_Metadata WHERE Incoming_File_Type_Code in ('CSAT') AND Correlation_ID = '55df0562-050c-44b7-9b13-be5ea6109247')
and market_code in (select distinct Analytical_Market_Code from opera.Category_Rule
)

) A




SELECT COUNT(*) FROM 
(
select os.occupancy_dt,os.Room_Departures,os.market_code,os.room_type  
from opera.stage_summary as os
where 
market_code in (select distinct Analytical_Market_Code from opera.Category_Rule)

) A


SELECT COUNT(*) FROM 
(
select os.occupancy_dt,os.Room_Departures,os.market_code,os.room_type  
from opera.stage_summary as os inner join (select distinct Analytical_Market_Code from opera.Category_Rule) as x on
os.market_code = x.Analytical_Market_Code 

) A
