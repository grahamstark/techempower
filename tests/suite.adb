--
-- Created by ada_generator.py on 2013-12-01 16:44:15.074334
-- 
with AUnit.Test_Suites; use AUnit.Test_Suites;

with Techempower_Test;

function Suite return Access_Test_Suite is
        result : Access_Test_Suite := new Test_Suite;
begin
        Add_Test( result, new Techempower_Test.test_Case ); -- Adrs_Data_Ada_Tests.Test_Case
        return result;
end Suite;
