pageextension 57501 SalesOrderCard_ResStatusField extends "Sales Order"
{
    layout
    {

        addafter("Status")
        {
            field("Reservation Status"; Rec."Reservation Status")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
    }

}