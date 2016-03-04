# mysql-ut

### Installation
This is WIP (work-in-progress), in order to **install the test bench** run following (with appropriate database privileges):
```
DROP DATABASE utest;
CREATE DATABASE utest DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
USE utest;
```
Then in you GUI or commandline do:
```
USE utest;
```
and install **build.sql** script.

### Example test

Use **test-example.sql** as a template for your first SQL Unit Test with mysql-ut:
1. Initialise your test and give it a name
```
CALL utest.initTest();
SET @temp = (SELECT utest.setTestNameId(utest.saveTestName('My test #1')));
```
2. Call your test's assertions:
```
CALL utest.utAssertEqual('Leo', 234, 'This would not pass');
CALL utest.utAssertEqual(123, 123, 'This is OK');
```
You can evaluate "TRUE" using (1 = 1) construct - see below:
```
CALL utest.utAssertEqual(
    (SELECT 100>10),
    (1 = 1), /*** this is how we represent TRUE ***/
    'Count greater than 10'
);
```
3. Finally, you can invoke reporter
```
CALL utest.reportTestResults();
```
expected outcome should be similar to this one:
```
details
Test name: My test #1
Start: 2016-03-04 10:55:53
End:   2016-03-04 10:55:53

1. FAIL - This would not pass
2. PASS - This is OK
3. PASS - Count greater than 10
```

WIP: @todo: JSON  Reporter