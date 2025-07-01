NAMESPACE Simatic.Ax.Actuators    
    TYPE
        SuperVisionMode : (None, PositionControl, Action, Reaction) := None;
    END_TYPE

    TYPE
        SuperVisionError : WORD (None := WORD#16#0000, PositionError := WORD#16#0001, ActionError := WORD#16#0002, ResponseError := WORD#16#0003) := None;
    END_TYPE
END_NAMESPACE
