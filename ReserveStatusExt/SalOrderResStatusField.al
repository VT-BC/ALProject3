pageextension 57500 SalesOrder_ReservStatusField extends "Sales Order List"
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
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(Creation)
        {
            //group(MyNewActionGroup)
            //{
            action(MyNewAction)
            {
                Caption = 'Autoreserve';



                trigger OnAction();
                var
                    ReservSalesHeader: Codeunit SetReservStatus;

                begin
                    //Message('My message');
                    ReservSalesHeader.Run(Rec);
                end;


            }
            //}
        }
    }

}