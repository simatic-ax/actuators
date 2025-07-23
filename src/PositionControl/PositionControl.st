USING System.Timer;

NAMESPACE Simatic.Ax.Actuators
    /// Class providing control logic for actuator positions.
    /// Input: Position control commands via Set, Reset, Hold methods.
    /// Returns: Position state and cyclic output signal.
    CLASS PositionControl
        IMPLEMENTS itfPositionControl

        // Public variables
        VAR PUBLIC
            /// Defines the behavior of the actuator position: ActiveHold or SelfHold.
            Behavior : PositionBehavior;
        END_VAR

        // Protected variables
        VAR PROTECTED
            /// Internal state of the actuator position.
            _q : BOOL;
        END_VAR

        /// Writes the cyclic output signal.
        /// Input: None.
        /// Returns: Q - Output signal representing the actuator state.
        METHOD PUBLIC WriteCyclic
            VAR_OUTPUT
                /// Output signal representing the actuator state.
                Q : BOOL;
            END_VAR
            Q := _q;
        END_METHOD

        /// Sets the actuator position to active.
        /// Input: None.
        /// Returns: BOOL indicating the operation result.
        METHOD PUBLIC Set : BOOL
            _q := TRUE;
            Set := _q;
        END_METHOD

        /// Resets the actuator position to inactive.
        /// Input: None.
        /// Returns: BOOL indicating the operation result.
        METHOD PUBLIC Reset : BOOL
            _q := FALSE;
            Reset := _q;
        END_METHOD

        /// Holds the actuator position based on the configured behavior.
        /// Input: None.
        /// Returns: BOOL indicating the operation result.
        METHOD PUBLIC Hold : BOOL
            IF (Behavior = PositionBehavior#ActiveHold) THEN
                _q := TRUE;
            ELSE
                _q := FALSE;
            END_IF;
            Hold := _q;
        END_METHOD
    END_CLASS
END_NAMESPACE
