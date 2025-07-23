USING System.Timer;

NAMESPACE Simatic.Ax.Actuators
    /// Internal class providing a dummy implementation of the itfPositionControl interface.
    /// Input: None.
    /// Returns: Default BOOL values for all methods (no actual functionality).
    CLASS INTERNAL NullPositionControl
        IMPLEMENTS itfPositionControl

        /// Dummy implementation of Set method.
        /// Input: None.
        /// Returns: Default BOOL value.
        METHOD PUBLIC Set : BOOL
            ;
        END_METHOD

        /// Dummy implementation of Reset method.
        /// Input: None.
        /// Returns: Default BOOL value.
        METHOD PUBLIC Reset : BOOL
            ;
        END_METHOD

        /// Dummy implementation of Hold method.
        /// Input: None.
        /// Returns: Default BOOL value.
        METHOD PUBLIC Hold : BOOL
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE
