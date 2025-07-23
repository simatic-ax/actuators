USING System.Timer;

NAMESPACE Simatic.Ax.Actuators
    /// Interface for defining methods to control actuator positions.
    /// Input: Various control commands.
    /// Returns: BOOL indicating success/state of the operation.
    INTERFACE itfPositionControl
        /// Sets the actuator position to active.
        /// Input: None.
        /// Returns: BOOL indicating the operation result.
        METHOD Set : BOOL
        END_METHOD

        /// Holds the actuator position based on the configured behavior.
        /// Input: None.
        /// Returns: BOOL indicating the operation result.
        METHOD Hold : BOOL
        END_METHOD

        /// Resets the actuator position to inactive.
        /// Input: None.
        /// Returns: BOOL indicating the operation result.
        METHOD Reset : BOOL
        END_METHOD
    END_INTERFACE
END_NAMESPACE
