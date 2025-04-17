USING AxUnit.Assert;
USING Simatic.Ax.Commands;

NAMESPACE Simatic.Ax.Actuators

    // Helper function to await the completion of a command and return its state.
    FUNCTION Await : PlcOpen
        VAR_INPUT
            cmd : itfCommand;
        END_VAR

        IF (NOT cmd.Busy()) THEN
            IF cmd.Done() THEN
                Await := PlcOpen#Done;
                RETURN;
            ELSIF cmd.Error() THEN
                Await := PlcOpen#Error;
                RETURN;
            ELSIF cmd.CommandAborted() THEN
                Await := PlcOpen#Aborted;
                RETURN;
            ELSE
                Await := PlcOpen#Undefined;
                RETURN;
            END_IF;
        ELSE
            Await := PlcOpen#Busy;
            RETURN;
        END_IF;
    END_FUNCTION

    // Enumeration representing the possible states of a PLCOpen command.
    TYPE
        PlcOpen : (Busy, Done, Error, Aborted, Undefined) := Undefined;
    END_TYPE

END_NAMESPACE
