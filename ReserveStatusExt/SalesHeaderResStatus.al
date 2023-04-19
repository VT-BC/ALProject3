tableextension 57500 "ReserveStatusField" extends "Sales Header"
{
    fields
    {
        field(57500; "Reservation Status"; Option)
        {
            OptionMembers = "To be processed","No reservation","Partly","Completely";
            OptionCaptionML = ENU = 'To be processed,No reservation,Partly,Completely';
            DataClassification = ToBeClassified;
        }

    }
}