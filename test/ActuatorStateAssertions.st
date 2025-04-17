USING System.Strings;
USING AxUnit.ResultFunctions;

NAMESPACE Simatic.Ax.Actuators

    FUNCTION Equal
        VAR_INPUT
            expected : ActuatorState;
            actual : ActuatorState;
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
            messageStr := Concat('Expected = ', ToString(val := expected), ' Actual = ', ToString(actual));
            axunit_Fail(messageStr, file, line);
        END_IF;
        AxUnit.Assert.Equal(expected := TRUE, actual := expected = actual);
        ;
    END_FUNCTION

    FUNCTION NotEqual
        VAR_INPUT
            expected : ActuatorState;
            actual : ActuatorState;
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
            messageStr := Concat('Expected = ', ToString(expected), 'Actual = ', ToString(actual));
            axunit_Fail(messageStr, file, line);
        END_IF;
        AxUnit.Assert.Equal(expected := TRUE, actual := expected <> actual);
        ;
    END_FUNCTION


END_NAMESPACE