SELECT CONCAT(TRIM(R.fname), ' ', TRIM(R.lname)), R.handle, R.email, R.phone
FROM RECIPIENTS AS R