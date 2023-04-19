codeunit 57501 ReservSalesHeader
{
    TableNo = "Sales Header";

    trigger OnRun();

    var
        //SalesHeader: Record "Sales Header";
        ResMngmt: Codeunit ReservStatusProcess;

    begin
        //Clear(ResMngmt);
        //Rec."Reservation Status" := Rec."Reservation Status"::"To be processed";
        //Rec.Modify();
        //error('1 = ' + format(Rec."No."));
        ResMngmt.AutoReservSalesOrder(Rec);
    end;

}