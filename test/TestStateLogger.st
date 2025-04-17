USING AxUnit.Assert;

NAMESPACE Simatic.Ax.Actuators

    {TestFixture}
    CLASS TestStateLogger
        VAR
            _o, _oStateLess  : StateLogger;
        END_VAR

        {Setup}
        METHOD PUBLIC Setup
            _o := _oStateLess;
        END_METHOD

        {Test}
        METHOD PUBLIC TestIsActivated
            VAR

            END_VAR

;
        END_METHOD

       
    END_CLASS

END_NAMESPACE
