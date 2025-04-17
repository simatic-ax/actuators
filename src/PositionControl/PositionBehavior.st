USING System.Timer;

NAMESPACE Simatic.Ax.Actuators
    // Enumeration defining position behavior.
    TYPE
        PositionBehavior : (ActiveHold, SelfHold) := SelfHold; // SelfHold --> Set Q to false, ActiveHold --> Keep Q on True
    END_TYPE
END_NAMESPACE
