USING AxUnit.ResultFunctions;
USING System.Strings;

NAMESPACE AxUnit.Assert
  
    FUNCTION PUBLIC IsTrue
        VAR_INPUT
            condition : BOOL;
           
            {CallerFilePath}
            file : WSTRING[1024];
            {CallerLineNumber}
            line : INT;
        END_VAR

        IF condition THEN
            axunit_Succeed();
        ELSE
            axunit_Fail('Condition is not true', file, line);
        END_IF;

    END_FUNCTION

    FUNCTION PUBLIC IsFalse
        VAR_INPUT
            condition : BOOL;
           
            {CallerFilePath}
            file : WSTRING[1024];
            {CallerLineNumber}
            line : INT;
        END_VAR

        IF NOT condition THEN
            axunit_Succeed();
        ELSE
            axunit_Fail('Condition is not false', file, line);
        END_IF;

    END_FUNCTION

END_NAMESPACE