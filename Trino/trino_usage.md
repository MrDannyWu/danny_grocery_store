# Set timezone
```sql
SET TIME ZONE 'Asia/Shanghai';
```

1. 获取当前时间
```sql
-- hive
hive
select from_unixtime(unix_timestamp());  --> 2021-01-06 22:53:16    --精确到今天的时分秒
select from_unixtime(unix_timestamp('2021-12-07 13:01:03'),'yyyy-MM-dd HH:mm:ss'); -->2021-12-07 13:01:03 --精确到今天的时分秒指定格式
select current_date; --> 2021-01-06   -- 今天的年月日
select unix_timestamp(); --> 1609944783  --获取当前时间戳

-- trino
select now(); -- 或者select current_timestamp --> 2021-01-06 22:49:08.899 Asia/Shanghai  --精确到今天的时分秒毫秒且带时区
select current_date; --> 2021-01-06  -- 今天的年月日
select current_date - interval '1' day; --> 2021-01-05  --昨天的年月日
```

2.字符串日期转时间戳
```sql
-- hive
select unix_timestamp('2021-01-08 10:36:15','yyyy-MM-dd HH:mm:ss');  --> 输出long类型timestamp：1610073375

-- trino
select to_unixtime(cast('2021-01-08 13:53:36' as timestamp));  --> 输出long类型timestamp：1610085216
```

3.时间戳转字符串日期
```sql
-- hive
select from_unixtime(unix_timestamp(),'yyyy-MM-dd HH:mm:ss');  -->输出varchar类型日期：2021-01-08 15:04:08

-- trino
select format_datetime(from_unixtime(1610085216),'yyyy-MM-dd HH:mm:ss'); -->输出varchar类型日期：2021-01-08 13:53:36
```

4. 字符串日期格式转换
```sql
-- hive
select from_unixtime(unix_timestamp('2021-01-08 10:36:15','yyyy-MM-dd HH:mm:ss'),'yyyy-MM-dd'); -->输出varchar类型日期：2021-01-08
select to_date('2021-01-08 10:36:15');  -->输出varchar类型日期：2021-01-08
select to_date(from_unixtime(unix_timestamp('20210110','yyyyMMdd'))); -->输出varchar类型日期：2021-01-10

-- trino
select date(cast('2021-01-08 10:36:15' as timestamp));  --> 输出date类型日期：2021-01-08
select format_datetime(from_unixtime(to_unixtime(cast('2021-01-08 13:53:36' as timestamp))),'yyyy-MM-dd'); -->输出varchar类型日期：2021-01-08
select format_datetime(date_parse('20210110','%Y%m%d'),'yyyy-MM-dd'); -->输出varchar类型日期：2021-01-10
```

5. date类型转字符类型串日期
```sql
-- trino
SELECT format_datetime(cast('2021-06-19' as date), 'yyyy-MM-dd');  -- ->输出varchar类型日期：2021-06-19
```

6. 日期加减
```sql
-- hive
select date_add('2021-01-08', 2);  -->输出varchar类型日期：2021-01-10
select date_add(current_timestamp, 2); -->输出varchar类型日期：2021-01-10

-- trino
select date_add('day', -2, cast('2020-01-10' as date));  -->输出date类型日期：2021-01-08
select date_add('day', -2, current_date);   -->输出date类型日期：2021-01-06
select format_datetime(date_add('day', -1, cast('2021-06-19' as date)),'yyyy-MM-dd')
```

7. 日期截断
```sql
-- hive
-- dd当天， MM所在月第一天，yyyy所在年第一天
SELECT trunc(CURRENT_DATE,'MM');   -->输出与输入类型一致的日期：2022-03-01

-- trino
-- day当天， month所在月第一天，year所在年第一天
SELECT date_trunc('month',CURRENT_DATE); -->输出与输入类型一致的日期：2022-03-01
```

8. round 保留小数的方法
```sql
select count(*)*1.00 / count(*) from student;
```

9. CONCAT int 和 STRING 类型的数据时，要将 int 转换为 VARCHAR
```sql
SELECT CONCAT(CAST(123 AS VARCHAR), 'abc')
```

10. IFNULL 的替换
```sql
mysql: IFNULL(1,0) 
trino: coalesce(1,0) 
```

11. GROUP_CONCAT 的替换
```sql
mysql: GROUP_CONCAT()
trino: ARRAY_AGG()
```

12. CREATE TABLE LIKE existing_table_name
```sql
mysql: CREATE TABLE ods.table_1 LIKE ods.table_1;

trino: CREATE TABLE ods.table_1 ( LIKE ods.table_1);
```

13. SET TABLE PROPERTIES
```sql
-- 设置单个属性
ALTER TABLE people SET PROPERTIES x = 'y';
-- 设置多个属性
ALTER TABLE people SET PROPERTIES foo = 123, "foo bar" = 456;
-- 设置为默认值
ALTER TABLE people SET PROPERTIES x = DEFAULT;
```

14. SHOW CREATE TABLE
```sql
SHOW CREATE TABLE iceberg.ods.table_1;
```

15. Metadata tables
```sql
-- $PROPERTIES TABLE
SELECT * FROM ods."table_1$properties"

-- $HISTORY TABLE
SELECT * FROM ods."table_1$history"

-- $SNAPSHOTS TABLE
SELECT * FROM ods."table_1$snapshots"

-- $MANIFESTS TABLE
SELECT * FROM ods."table_1$manifests"

-- $PARTITIONS TABLE
SELECT * FROM ods."table_1$partitions"

-- $FILES TABLE
SELECT * FROM ods."table_1$files"

-- $REFS TABLE
SELECT * FROM ods."table_1$refs"

-- Metadata columns
SELECT *, "$path", "$file_modified_time"
FROM ods.table_1;

-- 如果您的查询很复杂并且包括连接大型数据集，则在表上运行ANALYZE可以通过收集有关数据的统计信息来提高查询性能：
ANALYZE ods.table_1;
SELECT * FROM user order by id;
-- 此查询收集所有列的统计信息。
-- 在宽表上，收集所有列的统计信息可能代价高昂。它通常也是不必要的——统计信息只对特定的列有用，比如连接键、谓词或分组键。您可以使用可选属性指定要分析的列子集columns：
ANALYZE table_name WITH (columns = ARRAY['col_1', 'col_2'])
```


16. USE SNAPSHOTS
```sql
SELECT snapshot_id,operation
FROM ods."table_1$snapshots"
ORDER BY committed_at DESC;


SELECT count(1)
FROM ods.table_1 FOR VERSION AS OF 1659056808518293404;
SELECT count(1)
FROM ods.table_1 FOR TIMESTAMP AS OF TIMESTAMP '2023-07-25 14:40:29.803 Asia/Shanghai'
```

17. SHOW STATS
```sql
SHOW STATS FOR ods.table_1
```

