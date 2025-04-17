USING System.Timer;

NAMESPACE Simatic.Ax.Actuators
    // Class providing control logic for actuator positions.
    CLASS PositionControl
        IMPLEMENTS itfPositionControl

        // Public variables
        VAR PUBLIC
            Behavior : PositionBehavior; // Defines the behavior of the actuator position: ActiveHold or SelfHold.
        END_VAR

        // Protected variables
        VAR PROTECTED
            _q : BOOL; // Internal state of the actuator position.
        END_VAR

        // Writes the cyclic output signal.
        METHOD PUBLIC WriteCyclic
            VAR_OUTPUT
                Q : BOOL; // Output signal representing the actuator state.
            END_VAR
            Q := _q;
        END_METHOD

        // Sets the actuator position to active.
        METHOD PUBLIC Set : BOOL
            _q := TRUE;
        END_METHOD

        // Resets the actuator position to inactive.
        METHOD PUBLIC Reset : BOOL
            _q := FALSE;
        END_METHOD

        // Holds the actuator position based on the configured behavior.
        METHOD PUBLIC Hold : BOOL
            IF (Behavior = PositionBehavior#ActiveHold) THEN
                _q := TRUE;
            ELSE
                _q := FALSE;
            END_IF;
        END_METHOD
    END_CLASS
END_NAMESPACE
