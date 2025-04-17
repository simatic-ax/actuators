USING AxUnit.Assert;

NAMESPACE Simatic.Ax.Actuators

    {TestFixture}
    CLASS TestEndswitch
        VAR
            _endswitch, _endswitchStateless  : Endswitch;
        END_VAR

        {Setup}
        METHOD PUBLIC Setup
            _endswitch := _endswitchStateless;
        END_METHOD

        {Test}
        METHOD PUBLIC TestIsActivated
            VAR
                signal : BOOL := TRUE;
                valid : BOOL := TRUE;
            END_VAR

            _endswitch.ReadCyclic(signal := TRUE, valid := valid);
            IsTrue(condition := _endswitch.IsActivated());
        END_METHOD

        {Test}
        METHOD PUBLIC TestHasReached
            VAR
                signal : BOOL := TRUE;
                valid : BOOL := TRUE;
            END_VAR

            _endswitch.ReadCyclic(signal := FALSE, valid := valid);
            _endswitch.ReadCyclic(signal := TRUE, valid := valid);
            IsTrue(condition := _endswitch.HasReached());
        END_METHOD

        {Test}
        METHOD PUBLIC TestHasLeft
            VAR
                signal : BOOL;
                valid : BOOL := TRUE;
            END_VAR

            _endswitch.ReadCyclic(signal := TRUE, valid := valid);
            _endswitch.ReadCyclic(signal := FALSE, valid := valid);
            IsTrue(condition := _endswitch.HasLeft());
        END_METHOD
    END_CLASS

END_NAMESPACE
