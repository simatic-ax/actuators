USING System.Strings;
USING AxUnit.ResultFunctions;
USING Simatic.Ax.Actuators;

NAMESPACE AxUnit.Assert

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
            messageStr := Concat('Expected = ', Simatic.Ax.Actuators.ToString(val := expected), ' Actual = ', Simatic.Ax.Actuators.ToString(actual));
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
            messageStr := Concat('Expected = ', Simatic.Ax.Actuators.ToString(expected), 'Actual = ', Simatic.Ax.Actuators.ToString(actual));
            axunit_Fail(messageStr, file, line);
        END_IF;
        AxUnit.Assert.Equal(expected := TRUE, actual := expected <> actual);
        ;
    END_FUNCTION


END_NAMESPACE