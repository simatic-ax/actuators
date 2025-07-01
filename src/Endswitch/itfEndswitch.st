USING System.Timer;

NAMESPACE Simatic.Ax.Actuators    

    // Interface for an endswitch, defining methods for monitoring and retrieving its state.
    INTERFACE itfEndswitch
        // Starts monitoring the endswitch with a specified monitoring time.
        METHOD EnableSupervision
            VAR_INPUT
                Mode : SuperVisionMode;
            END_VAR
        END_METHOD

        // Checks if the endswitch is currently activated.
        METHOD IsActivated : BOOL
        END_METHOD

        // Checks if the endswitch has been reached.
        METHOD HasReached : BOOL
        END_METHOD

        // Checks if the endswitch has been left.
        METHOD HasLeft : BOOL
        END_METHOD

        // Checks if the monitoring time has elapsed.
        METHOD TimeHasElapsed : BOOL
        END_METHOD
    END_INTERFACE
END_NAMESPACE
