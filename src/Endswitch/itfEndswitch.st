USING System.Timer;

NAMESPACE Simatic.Ax.Actuators    

    // Interface for an endswitch, defining methods for monitoring and retrieving its state.
    INTERFACE itfEndswitch
        // Starts monitoring the endswitch with a specified monitoring time.
        METHOD StartMonitoring
            VAR_INPUT
                MonitoringTime : LTIME; // Duration for monitoring.
            END_VAR
        END_METHOD

        // Disable monitoring the endswitch
        METHOD DisableMonitoring
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
