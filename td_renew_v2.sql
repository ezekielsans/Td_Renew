
 CREATE OR REPLACE FUNCTION public.td_renew_date()
 RETURNS character varying
 LANGUAGE plpgsql

AS 

$function$  

DECLARE

--> variables for insert

count_var_ integer;
ctd_no_var integer;
loop_count integer;
term_no_var_ integer;
due_date_var DATE = returncustomdate1(); -- + INTERVAL '1 DAY'/ THIS IS THE NEW TERM END DATE
due_date_is BOOLEAN = 'f'; --> set to false?
holi_date DATE; 


 BEGIN

 --> List - 'A' is the set of term end
term_end_list_var := (SELECT DISTINCT term_end FROM check_unrenewed_td WHERE term_end > 2020-04-22);
 
	WHILE due_date_is = 'f'
 LOOP
	due_date_is := 't';
	--span of days
	--INTERVAL using holiday + 1 month (get somewhere code with holiday sunday) = holi_date
	--'dow'  --> day of the week
	--IF SUNDAY, MOVE DUE DATE
		IF EXTRACT(dow FROM due_date_var + INTERVAL '1 DAY') = 0;
		THEN
   		 due_date_var := due_date_var + INTERVAL '1 DAY';
   		 due_date_is := 'f';
   	 END IF;

   	 --IF HOLIDAY, MOVE DUE DATE
   	 --FOR LOOOP IN HOLIDATE
   	 FOR holi_date IN (SELECT DISTINCT hdate FROM coop_fin_holiday_file WHERE hdate >= due_date_var + INTERVAL '1 DAY' ORDER BY hdate) 
 LOOP

   		 IF holi_date = due_date_var + INTERVAL '1 DAY' THEN
   			 due_date_var := due_date_var + INTERVAL '1 DAY';
   			 due_date_is := 'f';
   		 END IF;
   	 END LOOP;
    
  END LOOP;
    

due_date_var --> THIS IS THE NEW TERM END DATE... OLD TERM DATE IS THE TERMEND on CHECK UNRENEWED / LIST - 'A'
--> 1st loop checks the day if it is holiday or sunday
--> 2nd loop willl go inside the 1st loop to 

--> do this:
SELECT acctno FROM check_unrenewed_td where term_end = LIST[n] --> what is this list?
          
	--- loop acctno LIST - 'B'
	
	UPDATE coop_fin_class_td
	SET term_start = due_date_var, --one month
	term_end = new_term_end_,
	term_no = term_no + 1  
	WHERE ctd_no = ctd_no_var 
	RETURNING term_no INTO term_no_var_;
 --X
SELECT deposit_amount 
FROM coop_fin_class_td 
WHERE acctno in list B INTO var

SELECT td_class_recno 
FROM coop_fin_class_td 
WHERE acctno in list B INTO var

SELECT rate 
FROM td_prod_dtl (amt_bracket,term start OR term end)

	INSERT INTO coop_fin_td_term(term_no,term_start,term_end,deposit_amount,td_class_recno,rate)
	VALUES(term_no_var_,old_term_end_,new_term_end_,60778.11,10585,0.0075); --static values change based from above (X)

  END LOOP;

RAISE NOTICE 'acctno: %', ctd_no_var;
RETURN 'total acct: %' count_var_;
END;
$function$
;
