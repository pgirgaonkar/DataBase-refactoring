/****** Original Query *********/

select count(*) from
(
SELECT A.resort,A.occupancy_dt,A.Mkt_Seg_Code,A.Accom_Type_Capacity,0 AS Out_Of_Order_Rooms, 
              0 AS Out_Of_Service_Rooms,0 AS Rooms_Sold,0.0 AS Room_Revenue,0 AS Room_Arrivals, 
              0 AS Room_Departures,0.0 AS Total_Revenue,0.0 AS Food_Revenue,0 AS Cancelled_Rooms, 
              0 AS No_Show_Rooms,null AS Reservation_Type,A.Accom_Type_Code,A.Mkt_Seg_ID,A.Accom_Type_ID,
              (CASE WHEN Occupancy_DT<'2014-06-29' THEN  
                           (SELECT Data_Load_Metadata_ID 
                           FROM opera.Data_Load_Metadata 
                           WHERE Incoming_File_Type_Code IN ('PSAT')AND Correlation_ID = '55df0562-050c-44b7-9b13-be5ea6109247') 
                      ELSE 
                           (SELECT Data_Load_Metadata_ID 
                            FROM opera.Data_Load_Metadata 
                            WHERE Incoming_File_Type_Code IN ('CSAT')AND Correlation_ID = '55df0562-050c-44b7-9b13-be5ea6109247') 
               END) AS Data_Load_Metadata_ID 
              FROM  
                     (SELECT Accom_Type_Code,Accom_Type_Capacity,Accom_Type_ID,Mkt_Seg_Code,Mkt_Seg_ID,sos1.Occupancy_DT,sos1.resort 
                      FROM 
                           (SELECT * FROM 
                                  ( 
                                         SELECT Accom_Type_Code, Accom_Type_Capacity,Accom_Type_ID 
                                         FROM [dbo].[AType] 
                                         WHERE Status_ID = (SELECT [Status_ID] FROM [dbo].[Status] WHERE [Status_Name] = 'Active') 
                                  ) AS accomtype CROSS JOIN  
                               ( 
                                         SELECT Mkt_Seg_Code,Mkt_Seg_ID 
                                         FROM [dbo].[MSeg] 
                                         WHERE Status_ID = (SELECT [Status_ID] FROM [dbo].[Status] WHERE [Status_Name] = 'Active') 
                                         AND Mkt_Seg_Code <> '-1' and Mkt_Seg_Code IS NOT NULL AND len(Mkt_Seg_Code) <> 0 and Mkt_Seg_Code <> '' 
                                  ) AS mkt CROSS JOIN  
                                  ( 
                                         SELECT DISTINCT Resort FROM  opera.Stage_Summary 
                                  ) AS sos CROSS JOIN 
                                  ( 
                                         SELECT [calendar_date] as occupancy_dt 
                                         FROM dbo.calendar_dim 
                                         WHERE calendar_date between 
                                                (SELECT DATEADD(DAY,-PAST_DAYS,CAST(business_dt AS date)) FROM opera.Stage_Metadata) AND 
                                                (SELECT DATEADD(DAY,FUTURE_DAYS-1,CAST(business_dt AS date)) FROM opera.Stage_Metadata) 
                                  ) AS calDates
                           ) AS sos1 
                           LEFT JOIN  
                           ( 
                                  SELECT DISTINCT occupancy_dt,room_type,Market_Code 
                                  FROM opera.Stage_Summary 
                                  WHERE Market_Code IS NOT NULL AND len(Market_Code) <> 0 AND Market_Code <> '' 
                                  AND Data_Load_Metadata_ID IN 
                                         (SELECT Data_Load_Metadata_ID FROM opera.Data_Load_Metadata 
                                          WHERE Incoming_File_Type_Code IN ('CSAT','PSAT') AND Correlation_ID = '55df0562-050c-44b7-9b13-be5ea6109247' 
                                          )
                           ) AS sos2 
                           ON 
                           sos1.Occupancy_DT = sos2.Occupancy_DT 
                           AND sos1.Accom_Type_Code=sos2.Room_Type 
                           AND sos1.Mkt_Seg_Code = sos2.Market_Code 
                           WHERE sos2.Market_Code IS NULL 
                      ) AS A 
 ) b                   ;



/******* Improved query *********/
select count(*) from 
(
SELECT A.resort,A.occupancy_dt,A.Mkt_Seg_Code,A.Accom_Type_Capacity,0 AS Out_Of_Order_Rooms, 
              0 AS Out_Of_Service_Rooms,0 AS Rooms_Sold,0.0 AS Room_Revenue,0 AS Room_Arrivals, 
              0 AS Room_Departures,0.0 AS Total_Revenue,0.0 AS Food_Revenue,0 AS Cancelled_Rooms, 
              0 AS No_Show_Rooms,null AS Reservation_Type,A.Accom_Type_Code,A.Mkt_Seg_ID,A.Accom_Type_ID,
              (CASE WHEN Occupancy_DT<'2014-06-29' THEN  
                           psat
                     ELSE 
                           csat
              END) AS Data_Load_Metadata_ID 
               /*, 
              (CASE WHEN Occupancy_DT<'2014-06-29' THEN  
                           (SELECT Data_Load_Metadata_ID 
                           FROM opera.Data_Load_Metadata 
                           WHERE Incoming_File_Type_Code IN ('PSAT')AND Correlation_ID = '55df0562-050c-44b7-9b13-be5ea6109247') 
                      ELSE 
                           (SELECT Data_Load_Metadata_ID 
                            FROM opera.Data_Load_Metadata 
                            WHERE Incoming_File_Type_Code IN ('CSAT')AND Correlation_ID = '55df0562-050c-44b7-9b13-be5ea6109247') 
               END) AS Data_Load_Metadata_ID */
              FROM  
                     (SELECT Accom_Type_Code,Accom_Type_Capacity,Accom_Type_ID,Mkt_Seg_Code,Mkt_Seg_ID,sos1.Occupancy_DT,sos1.resort 
                      FROM 
                           (SELECT * FROM 
                                  ( 
                                         SELECT Accom_Type_Code, Accom_Type_Capacity,Accom_Type_ID 
                                         FROM [dbo].[AType] 
                                         WHERE Status_ID = (SELECT [Status_ID] FROM [dbo].[Status] WHERE [Status_Name] = 'Active') 
                                  ) AS accomtype CROSS JOIN  
                               ( 
                                         SELECT Mkt_Seg_Code,Mkt_Seg_ID 
                                         FROM [dbo].[MSeg] 
                                         WHERE Status_ID = (SELECT [Status_ID] FROM [dbo].[Status] WHERE [Status_Name] = 'Active') 
                                         AND Mkt_Seg_Code <> '-1' and Mkt_Seg_Code IS NOT NULL AND len(Mkt_Seg_Code) <> 0 and Mkt_Seg_Code <> '' 
                                  ) AS mkt CROSS JOIN  
                                  ( 
                                         SELECT /*DISTINCT*/ top 1 Resort FROM  opera.Stage_Summary 
                                  ) AS sos CROSS JOIN 
                                  ( 
                                         SELECT [calendar_date] as occupancy_dt 
                                         FROM dbo.calendar_dim 
                                         WHERE calendar_date between 
                                                (SELECT DATEADD(DAY,-PAST_DAYS,CAST(business_dt AS date)) FROM opera.Stage_Metadata) AND 
                                                (SELECT DATEADD(DAY,FUTURE_DAYS-1,CAST(business_dt AS date)) FROM opera.Stage_Metadata) 
                                  ) AS calDates
                           ) AS sos1 
                           LEFT JOIN  
                           ( 
                                  SELECT DISTINCT occupancy_dt,room_type,Market_Code 
                                  FROM opera.Stage_Summary 
                                  WHERE Market_Code IS NOT NULL AND len(Market_Code) <> 0 AND Market_Code <> '' 
                                  /*AND Data_Load_Metadata_ID IN 
                                         (SELECT Data_Load_Metadata_ID FROM opera.Data_Load_Metadata 
                                          WHERE Incoming_File_Type_Code IN ('CSAT','PSAT') AND Correlation_ID = :correlationId 
                                          )*/
                           ) AS sos2 
                           ON 
                           sos1.Occupancy_DT = sos2.Occupancy_DT 
                           AND sos1.Accom_Type_Code=sos2.Room_Type 
                           AND sos1.Mkt_Seg_Code = sos2.Market_Code 
                           WHERE sos2.Market_Code IS NULL 
                      ) AS A  
                      inner join 
                      (
                     select max(psat) as psat, max(csat) as csat from
                           (
                           SELECT  Data_Load_Metadata_ID as psat, 1 as csat
                                                       FROM opera.Data_Load_Metadata 
                                                       WHERE Incoming_File_Type_Code IN ('PSAT')AND Correlation_ID = '55df0562-050c-44b7-9b13-be5ea6109247'
                                                union 
                                                       SELECT 2 as psat, Data_Load_Metadata_ID as csat
                                                       FROM opera.Data_Load_Metadata 
                                                        WHERE Incoming_File_Type_Code IN ('CSAT')AND Correlation_ID = '55df0562-050c-44b7-9b13-be5ea6109247'
                           ) as x
                     ) as y on 1=1
) b                     ;
