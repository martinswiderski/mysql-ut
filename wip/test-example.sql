
CALL utest.initTest();
SET @temp = (SELECT utest.setTestNameId(utest.saveTestName('My test #1')));

CALL utest.utAssertEqual('Leo', 234, 'This would not pass');

CALL utest.utAssertEqual(123, 123, 'This is OK');

CALL utest.utAssertEqual(
    (SELECT 100>10),
    (1 = 1), /*** this is how we represent TRUE ***/
    'Count greater than 10'
);

CALL utest.reportTestResults();
