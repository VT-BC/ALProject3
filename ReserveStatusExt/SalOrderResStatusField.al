pageextension 57502 SalesOrder_ReservStatusField extends "Sales Order List"
{
    layout
    {

        addafter("Sell-to Customer Name")
        {
            field("Reservation Status"; Rec."Reservation Status")
            {
                ApplicationArea = All;
            }
        }
    }

}