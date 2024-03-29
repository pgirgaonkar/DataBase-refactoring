

select * into tx from  transactions;

select distinct charge_no from [finance].[dbo].[Transactions];

update [finance].[dbo].[Transactions] set [charge_code] = 'AB' where [charge_no] % 10 <4;
update [finance].[dbo].[Transactions] set [charge_code] = 'XY' where [charge_no] % 10 = 5;
update [finance].[dbo].[Transactions] set [charge_code] = 'PQ' where [charge_no] % 10 = 6;
update [finance].[dbo].[Transactions] set [charge_code] = 'RT' where [charge_no] % 10 = 7;
update [finance].[dbo].[Transactions] set [charge_code] = 'MN' where [charge_no] % 10 > 8;


update [finance].[dbo].[Transactions] set [charge_code] = '' 

DECLARE @charge_code VARCHAR(2);
DECLARE @CursorVar CURSOR;

SET @CursorVar = CURSOR SCROLL DYNAMIC
FOR
SELECT top 500 charge_code
FROM [finance].[dbo].[Transactions]
where [charge_no] % 10 = 5;

OPEN @CursorVar;

FETCH NEXT FROM @CursorVar into @charge_code;
WHILE @@FETCH_STATUS = 0
BEGIN
	set @charge_code = 'XY';
    FETCH NEXT FROM @CursorVar into @charge_code;
END;

CLOSE @CursorVar;
DEALLOCATE @CursorVar;

update  top (500) [finance].[dbo].[Transactions]  set [charge_code] = 'XY' where [charge_no] % 10 = 5;

/****** Script for SelectTopNRows command from SSMS  ******/


declare @charge_code nvarchar(2);
set  @charge_code = N'XY';

SELECT [charge_no]
      ,[member_no]
      ,[provider_no]
      ,[category_no]
      ,[charge_dt]
      ,[charge_amt]
      ,[statement_no]
      ,[charge_code]
  FROM [finance].[dbo].[Transactions]
  where charge_code = @charge_code;