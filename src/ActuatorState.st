NAMESPACE Simatic.Ax.Actuators

    // Enumeration representing the possible states of an actuator.
    TYPE
        ActuatorState : (
            InHomePosition,       // Actuator is in the home position.
            MoveToWorkPosition,   // Actuator is moving to the first work position.
            MoveToWorkPosition2,  // Actuator is moving to the second work position.
            InWorkPosition,       // Actuator is in the first work position.
            InWorkPosition2,      // Actuator is in the second work position.
            MoveToHomePosition,   // Actuator is moving to the home position.
            Error,                // Actuator is in an error state.
            Undefined             // Actuator state is undefined.
        ) := Undefined;
    END_TYPE

    
    // TYPE Definition: Error
    // This type defines a WORD enumeration used to represent various error states for an actuator.
    // Each error state is associated with a specific hexadecimal value:
    // - None: Default value, indicating no error (WORD#16#7000).
    // - SensorsNotPlausible: Indicates that the sensors are providing implausible data (WORD#16#8001).
    // - HomePositionNotReached: Indicates that the actuator failed to reach the home position (WORD#16#8002).
    // - WorkPositionNotReached: Indicates that the actuator failed to reach the work position (WORD#16#8003).
    // - WorkPosition2NotReached: Indicates that the actuator failed to reach the second work position (WORD#16#8004).
    // The default value for this type is set to None.
    TYPE
        Error : WORD (None := WORD#16#7000, SensorsNotPlausible := WORD#16#8001,  HomePositionNotReached := WORD#16#8002, WorkPositionNotReached := WORD#16#8003, WorkPosition2NotReached := WORD#16#8004) := None;
    END_TYPE

END_NAMESPACE
