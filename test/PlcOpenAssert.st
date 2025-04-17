USING Simatic.Ax.Actuators;
USING System.Strings;
USING AxUnit.ResultFunctions;

NAMESPACE AxUnit.Assert

    FUNCTION Equal
        VAR_INPUT
            expected : PlcOpen;
            actual : PlcOpen;
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
        Equal(expected := TRUE, actual := expected = actual);
        ;
    END_FUNCTION

    FUNCTION NotEqual
        VAR_INPUT
            expected : PlcOpen;
            actual : PlcOpen;
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
            messageStr := Concat('Expected = ', ToString(expected), ' Actual = ', ToString(actual));
            axunit_Fail(messageStr, file, line);
        END_IF;
        Equal(expected := TRUE, actual := expected <> actual);
        ;
    END_FUNCTION

    FUNCTION ToString : STRING
        VAR_INPUT
            val : PlcOpen;
        END_VAR
        CASE val OF
            PlcOpen#Undefined :
                ToString := 'Undefined';
                RETURN;
            PlcOpen#Busy :
            ToString := 'Busy';
            RETURN;
            PlcOpen#Done :
            ToString := 'Done';
            RETURN;
            PlcOpen#Error :
            ToString := 'Error';
            RETURN;
            PlcOpen#Aborted :
            ToString := 'Aborted';
            RETURN;
           
        END_CASE;
        ;
    END_FUNCTION

END_NAMESPACE