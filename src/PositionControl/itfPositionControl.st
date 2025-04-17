USING System.Timer;

NAMESPACE Simatic.Ax.Actuators
    // Interface for defining methods to control actuator positions.
    INTERFACE itfPositionControl
        // Sets the actuator position to active.
        METHOD Set : BOOL
        END_METHOD

        // Holds the actuator position based on the configured behavior.
        METHOD Hold : BOOL
        END_METHOD

        // Resets the actuator position to inactive.
        METHOD Reset : BOOL
        END_METHOD
    END_INTERFACE
END_NAMESPACE
