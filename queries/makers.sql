SELECT CONCAT(TRIM(S.fname), ' ', TRIM(S.lname)), S.handle, S.email, S.phone
FROM SENDERS AS S;