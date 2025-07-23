NAMESPACE Simatic.Ax.Actuators    
    TYPE
        SuperVisionMode : (None, 
                                 PositionControl, Action, Reaction) := None;
    END_TYPE

    TYPE
        /// Represents different types of supervision errors that can occur in the system.
        /// None: No error has occurred.
        /// PositionError: Indicates an unexpected change in the actuator's position.
        /// ActionError: Indicates that no action occurred after initiating a command, such as MoveToWorkPosition, and the current position was not left.
        /// ReactionError: Indicates that the target position was not reached, despite the command being executed.
        SuperVisionState : WORD (None := WORD#16#0000, 
                                 EvaluatingPosition  := WORD#16#7001, 
                                 EvaluatingAction    := WORD#16#7002, 
                                 EvaluatingRecaction := WORD#16#7003, 
                                 PositionError       := WORD#16#8001, 
                                 ActionError         := WORD#16#8002, 
                                 ReactionError       := WORD#16#8003) := None;
    END_TYPE
END_NAMESPACE
