USING System.Strings;
USING AxUnit.ResultFunctions;

NAMESPACE AxUnit.Assert

    FUNCTION Equal
        VAR_INPUT
            expected : STRING;
            actual : STRING;
            {CallerFilePath}
            file : WSTRING[1024];
            {CallerLineNumber}
            line : INT;
        END_VAR
        VAR_TEMP
            messageStr : STRING;
        END_VAR
        
        IF expected = actual THEN
            axunit_Succeed();
        ELSE
            messageStr := Concat('Expected = ', expected, ' Actual = ', actual);
            axunit_Fail(messageStr, file, line);
        END_IF;
        Equal(expected := TRUE, actual := expected = actual);
        ;
    END_FUNCTION

    FUNCTION NotEqual
        VAR_INPUT
            expected : STRING;
            actual : STRING;
            {CallerFilePath}
            file : WSTRING[1024];
            {CallerLineNumber}
            line : INT;
        END_VAR
        VAR_TEMP
            messageStr : STRING;
        END_VAR
        
        IF expected = actual THEN
            axunit_Succeed();
        ELSE
            messageStr := Concat('Expected = ', expected, 'Actual = ', actual);
            axunit_Fail(messageStr, file, line);
        END_IF;
        Equal(expected := TRUE, actual := expected <> actual);
        ;
    END_FUNCTION

END_NAMESPACE