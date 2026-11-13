USE review_kantin

UPDATE USERS
SET role = 'owner'
WHERE email IN (
    'salll@example.com'
);

SELECT * FROM USERS