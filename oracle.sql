/* Starting point for wk8 Oracle assignment */


/* Create an insert_contact function that writes the following five tables: 
member
contact
address 
street_address
telephone 
Create an insert_contact procedure that writes to all five tables,
and change the SELECT-INTO logic into a standalone get_user_id
local function like the get_lookup_type local function */

/* We are taking in all of these parameters:
Then we will spread these parameters across 5 tables */
CREATE OR REPLACE PROCEDURE insert_contact
( pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2
, pv_account_number      VARCHAR2
, pv_member_type         VARCHAR2
, pv_credit_card_number  VARCHAR2
, pv_credit_card_type    VARCHAR2
, pv_street_address      VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_address_type        VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_number    VARCHAR2
, pv_telephone_type      VARCHAR2
, pv_user_name           VARCHAR2 ) IS

  /* Declare local constants. 
  This logs a date for when we inserted the new client into the database*/
  lv_current_date      DATE := TRUNC(SYSDATE);

  /* Declare a who-audit variables. */
  lv_member_id         NUMBER :=0; 
  lv_created_by        NUMBER;
  lv_updated_by        NUMBER;
  lv_system_user_id    NUMBER;

  /* Declare type variables. */
  lv_member_type       NUMBER;
  lv_credit_card_type  NUMBER;
  lv_contact_type      NUMBER;
  lv_address_type      NUMBER;
  lv_telephone_type    NUMBER;

/* This is going to pass in a table name, column name, type name, and pass back to us a 4-digit code */
  FUNCTION get_lookup_type 
  ( pv_table_name    VARCHAR2
  , pv_column_name   VARCHAR2
  , pv_type_name     VARCHAR2 ) RETURN NUMBER IS

    /* Declare a return variable. */
    lv_retval  NUMBER := 0;

    /* Declare a local cursor. */
    CURSOR get_lookup_value
    ( cv_table_name    VARCHAR2
    , cv_column_name   VARCHAR2
    , cv_type_name     VARCHAR2 ) IS
      SELECT common_lookup_id
      FROM   common_lookup
      WHERE  common_lookup_table = cv_table_name
      AND    common_lookup_column = cv_column_name
      AND    common_lookup_type = cv_type_name;

  BEGIN

    /* Find a valid value. */
    FOR i IN get_lookup_value(pv_table_name, pv_column_name, pv_type_name) LOOP
      lv_retval := i.common_lookup_id;
    END LOOP;

    /* Return the value, where a 0 always fails the insert statements. */
    RETURN lv_retval;
  END get_lookup_type;
  
  /* Convert the member account_number into a surrogate member_id value. */
  /* This function is very much like what the get_grandma_id is: */
  FUNCTION get_member_id
  ( pv_account_number VARCHAR2) RETURN NUMBER IS
  
    /* Local return variable. */
    lv_retval  NUMBER := 0;  -- Default value is 0.
 
    /* A cursor that lookups up a member's ID by their account number. */
    /* Will look much like the CURSOR in get_grandma_id */
    CURSOR find_member_id
    ( cv_account_number  VARCHAR2) IS
      SELECT member_id
      FROM   member
      WHERE  account_number = cv_account_number;
    /* select from member table.  */ 
  BEGIN  
    /* 
     *  Write a FOR-LOOP that:
     *    Assign a member_id as the return value when a row exists.
     */
    FOR i IN find_member_id(pv_account_number) LOOP
        lv_retval := i.member_id;
    END LOOP;
 
    /* Return 0 when no row found and the member_id when a row is found. */
    RETURN lv_retval;
  END get_member_id;
  
BEGIN
  /* Get the member_type ID value. 
  This */
  lv_member_type := get_lookup_type('MEMBER','MEMBER_TYPE', pv_member_type);

  /* Get the credit_card_type ID value. */
  lv_credit_card_type := get_lookup_type('MEMBER','CREDIT_CARD_TYPE', pv_credit_card_type);

  /* Get the contact_type ID value. */
  lv_contact_type := get_lookup_type('CONTACT','CONTACT_TYPE', pv_contact_type);

  /* Get the address_type ID value. */
  lv_address_type := get_lookup_type('ADDRESS','ADDRESS_TYPE', pv_address_type);

  /* Get the telephone_type ID value. */
  lv_telephone_type := get_lookup_type('TELEPHONE','TELEPHONE_TYPE', pv_telephone_type);

  /*
   *  Convert the system_user_name value into a surrogate system_user_id value
   *  and assign the system_user_id value to the local lv_system_user_id variable.
   */
  SELECT system_user_id
  INTO   lv_system_user_id
  FROM   system_user
  WHERE  system_user_name = pv_user_name;

  /* Assign the system_user_id value to these local variables. */
  lv_created_by := lv_system_user_id;
  lv_updated_by := lv_system_user_id;

  /* Set save point. */
  SAVEPOINT start_point;

  /*
   *  Identify whether a member account exists and assign it's value
   *  to a local variable.
   */
lv_member_id := get_member_id(pv_account_number);

  IF lv_member_id = 0 THEN  
    INSERT INTO member
    (member_id
    , member_type
    , account_number
    , credit_card_number
    , credit_card_type
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date)
    VALUES
    ( member_s1.NEXTVAL
    , lv_member_type
    , pv_account_number
    , pv_credit_card_number
    , lv_credit_card_type
    , lv_created_by
    , lv_current_date
    , lv_created_by
    , lv_current_date)
    RETURNING member_id INTO lv_member_id;

     /*  Conditionally insert a new member account into the member table */
     /*  only when a member account does not exist. */

    lv_member_id := member_s1.CURRVAL;
  END IF;

  /* Insert into contact table. */
  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , first_name
  , middle_name
  , last_name)
  VALUES
  ( contact_id_seq.NEXTVAL
  , lv_member_id
  , lv_contact_type
  , pv_first_name
  , pv_middle_name
  , pv_last_name);

  /* Insert into address table. */
  INSERT INTO address
  ( address_id
  , contact_id
  , address_type
  , city 
  , state_province 
  , postal_code 
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( address_id_seq.NEXTVAL
  , contact_id_seq.CURRVAL 
  , lv_address_type 
  , pv_city 
  , pv_state_province
  , pv_postal_code
  , lv_created_by
  , lv_current_date 
  , lv_updated_by 
  , lv_current_date);

  /* Insert into street_address table. */
  /* line number: use a literal value of 1. This is mandatory */
  INSERT INTO street_address
  ( address_id 
  , line_number 
  , street_address)
  VALUES
  ( address_id_seq.CURRVAL 
  , 1 
  , pv_street_address );
  
  /* Insert into telephone table. */
  INSERT INTO telephone
  ( telephone_id
  , contact_id 
  , address_id
  , telephone_type 
  , country_code 
  , area_code 
  , telephone_number 
  , created_by 
  , creation_date 
  , last_updated_by 
  , last_update_date)
  VALUES 
  ( telephone_id_seq.NEXTVAL 
  , contact_id_seq.CURRVAL 
  , address_id_seq.CURRVAL 
  , lv_telephone_type 
  , pv_country_code 
  , pv_area_code 
  , pv_telephone_number
  , lv_created_by
  , lv_current_date
  , lv_updated_by
  , lv_current_date);

  /* Commit the writes to all four tables. */
  COMMIT;

/* Always comment out the exception code until you get your code working 
EXCEPTION
  /* Catch all errors. */
  WHEN OTHERS THEN
    /* Unremark the following line to generate an error message. */
    -- dbms_output.put_line('['||SQLERRM||']');
    ROLLBACK TO start_point;
END insert_contact;
/
*/

/* TEST CASE:
Deploy the insert_contact procedure.
run the following update statement first to ensure all of the 
system_user_name values are unique: */
UPDATE system_user
SET    system_user_name = system_user_name || ' ' || system_user_id
WHERE  system_user_name = 'DBA';

/* Then run the following anonymous block to clean prior test data: */
BEGIN 
  DELETE FROM telephone WHERE contact_id > 1007; 
  DELETE FROM street_address WHERE address_id > 1007; 
  DELETE FROM address WHERE address_id > 1007;
  DELETE FROM transaction WHERE rental_id > 1007;
  DELETE FROM rental_item WHERE rental_id > 1007;
  DELETE FROM rental WHERE rental_id > 1007;
  DELETE FROM contact WHERE contact_id > 1007;
  DELETE FROM member WHERE member_id > 1007;
END;

/* Test the procedure with the following two anonymous blocks: */
BEGIN
  /* Call procedure once. */
  insert_contact(
      pv_first_name         => 'Charles'
    , pv_middle_name        => 'Francis'
    , pv_last_name          => 'Xavier'
    , pv_contact_type       => 'CUSTOMER'
    , pv_account_number     => 'SLC-000008'
    , pv_member_type        => 'INDIVIDUAL'
    , pv_credit_card_number => '7777-6666-5555-4444'
    , pv_credit_card_type   => 'DISCOVER_CARD'
    , pv_street_address     => '1407 Graymalkin Lane' 
    , pv_city               => 'Bayville'
    , pv_state_province     => 'New York'
    , pv_postal_code        => '10032'
    , pv_address_type       => 'HOME'
    , pv_country_code       => '001'
    , pv_area_code          => '207'
    , pv_telephone_number   => '111-1234'
    , pv_telephone_type     => 'HOME'
    , pv_user_name          => 'DBA 2'
    );

  /* Call procedure twice. */
  insert_contact(
      pv_first_name         => 'James'
    , pv_middle_name        => ''
    , pv_last_name          => 'Xavier'
    , pv_contact_type       => 'CUSTOMER'
    , pv_account_number     => 'SLC-000008'
    , pv_member_type        => 'INDIVIDUAL'
    , pv_credit_card_number => '7777-6666-5555-4444'
    , pv_credit_card_type   => 'DISCOVER_CARD'
    , pv_street_address     => '1407 Graymalkin Lane' 
    , pv_city               => 'Bayville'
    , pv_state_province     => 'New York'
    , pv_postal_code        => '10032'
    , pv_address_type       => 'HOME'
    , pv_country_code       => '001'
    , pv_area_code          => '207'
    , pv_telephone_number   => '111-1234'
    , pv_telephone_type     => 'HOME'
    , pv_user_name          => 'DBA 2'
    );
END;
/

/* Then verify the results with the following query: */
COLUMN account_number  FORMAT A10  HEADING "Account|Number"
COLUMN contact_name    FORMAT A30  HEADING "Contact Name"
SELECT m.account_number
,      c.last_name ||', '||c.first_name AS contact_name
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id
WHERE  m.account_number = 'SLC-000008';