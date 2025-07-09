USING System.Timer;
USING Simatic.Ax.IO.Input;
NAMESPACE Simatic.Ax.Actuators    
    
    INTERFACE itfBooleanUpdate
        // Reads the cyclic signal and updates the internal state of the endswitch.
        METHOD Update
            VAR_INPUT
                signal : BOOL;       // Current signal state.
                valid : BOOL := TRUE; // Indicates if the signal is valid.
                default : BOOL := FALSE; // Default signal state.
            END_VAR
        END_METHOD
    END_INTERFACE

END_NAMESPACE
