USING System.Timer;

NAMESPACE Simatic.Ax.Actuators
    // Internal class providing a dummy implementation of the itfPosition interface.
    CLASS INTERNAL NullPositionControl
        IMPLEMENTS itfPositionControl

        // Dummy implementation of Set method.
        METHOD PUBLIC Set : BOOL
            ;
        END_METHOD

        // Dummy implementation of Reset method.
        METHOD PUBLIC Reset : BOOL
            ;
        END_METHOD

        // Dummy implementation of Hold method.
        METHOD PUBLIC Hold : BOOL
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE
