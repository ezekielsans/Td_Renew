SELECT use_template()

SELECT *
FROM check_unrenewed_td
WHERE term_end::text ~ '2023-08-10'::text
ORDER BY 1

SELECT *
FROM coop_fin_class_td
WHERE acctno ='TD0006482'
TD0006482


SELECT *
FROM coop_fin_td_term
WHERE td_class_recno =10585

SELECT cls 
                                 FROM UnionAllClassCdj cls 
                                 WHERE cls.clsNo ='CD23001897' 
                                 AND cls.accountCode = '211103010'
                                 AND cls.entryType = 'C'

SELECT td_renew_date('2023-08-10','2023-09-11')

CREATE OR REPLACE FUNCTION public.td_renew_date(old_term_end_ date, new_term_end_ date)
  RETURNS character varying AS
$BODY$  
DECLARE
count_var_ integer;
ctd_no_var integer;
loop_count integer;

term_no_var_ integer;


BEGIN
count_var_ := (SELECT COUNT(*)
		FROM check_unrenewed_td
		WHERE term_end::text ~ old_term_end_::text
		ORDER BY 1);
		
loop_count := 0;
LOOP
    loop_count := loop_count + 1;
    ctd_no_var := (SELECT ctd_no FROM coop_fin_class_td WHERE acctno IN ((WITH numbered_rows AS (  SELECT  ROW_NUMBER() OVER (ORDER BY td.acctno ASC) AS rowNumber,
			*
			FROM check_unrenewed_td td
			WHERE td.term_end::text ~ old_term_end_::text
			ORDER BY 1)
			SELECT acctno FROM numbered_rows WHERE rowNumber  = loop_count)));

	update coop_fin_class_td
	set term_start = old_term_end_, --one month
	term_end = new_term_end_,
	term_no = term_no + 1  --term_no = term_no+1 , para madagdagan
	where ctd_no = ctd_no_var 
	RETURNING term_no INTO term_no_var_;


--Single Insert
--ALTER TABLE 
--insert into coop_fin_td_term(term_no,term_start,term_end,deposit_amount,td_class_recno,rate)
	--values(term_no_var_,old_term_end_,new_term_end_,60778.11,10585,0.0075);

	insert into coop_fin_td_term(term_no,term_start,term_end,deposit_amount,td_class_recno,rate)
	values(term_no_var_,old_term_end_,new_term_end_,60778.11,10585,0.0075);

		
    RAISE NOTICE 'acctno: %', ctd_no_var;
    EXIT WHEN loop_count = count_var_;
END LOOP;


Return 'total acct: %' count_var_;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.td_renew_date(date, date)
  OWNER TO postgres;                        
